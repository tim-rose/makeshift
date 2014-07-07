#
# C.MK --Rules for building C objects and programs.
#
# Contents:
# main:              --rules for building executables from a file containing "main()".
# %.o:               --Compile a C file into an arch-specific sub-directory.
# %.h:               --Rules for installing header files.
# build:             --c-specific customisations for the "build" target.
# c-src-var-defined: --Test if "enough" of the C SRC variables are defined
# clean:             --c-specific customisations for the "clean" target.
# tidy:              --c-specific customisations for the "tidy" target.
# c-toc:             --Build the table-of-contents for C-ish files.
# c-src:             --c-specific customisations for the "src" target.
# tags:              --Build vi, emacs tags files.
# todo:              --Report unfinished work (identified by keyword comments)
#
-include $(C_SRC:%.c=$(archdir)/%-depend.mk)

C_DEFS	= $(C_OS_DEFS) $(C_ARCH_DEFS) -D__$(OS)__ -D__$(ARCH)__
C_FLAGS = $(C_OS_FLAGS) $(C_ARCH_FLAGS) $(CFLAGS)
C_WARN_FLAGS = -pedantic -Wall -Wmissing-prototypes \
	-Wmissing-declarations 	-Wimplicit -Wpointer-arith \
	-Wwrite-strings -Waggregate-return -Wnested-externs \
	-Wcast-align -Wshadow -Wstrict-prototypes -Wredundant-decls \
	-Wuninitialized -Wunused-parameter \
        -Wno-gnu-zero-variadic-macro-arguments \
	$(C_OS_WARN_FLAGS) $(C_ARCH_WARN_FLAGS)

C_CPP_FLAGS = $(CPPFLAGS) -I. -I$(includedir) $(C_OS_CPP_FLAGS) $(C_OS_ARCH_FLAGS)

C_ALL_FLAGS	= -std=c99 $(C_CPP_FLAGS) $(C_DEFS) $(C_FLAGS)

C_LD_FLAGS = -L$(libdir) $(LD_OS_FLAGS) $(LD_ARCH_FLAGS) $(LDFLAGS)
C_LD_LIBS	= $(LOADLIBES) $(LDLIBS)

C_OBJ	= $(C_SRC:%.c=$(archdir)/%.o)
C_MAIN	= $(C_MAIN_SRC:%.c=$(archdir)/%)

#
# main: --rules for building executables from a file containing "main()".
#
$(archdir)/%: %.c $(archdir)/%.o
	$(ECHO_TARGET)
	@echo $(CC) $(C_ALL_FLAGS) $(C_LD_FLAGS) $(archdir)/$*.o $(C_LD_LIBS)

	@$(CC) -o $@ $(C_WARN_FLAGS) $(C_ALL_FLAGS) $(C_LD_FLAGS) \
	    $(archdir)/$*.o $(C_LD_LIBS)

#
# %.o: --Compile a C file into an arch-specific sub-directory.
#
# Remarks:
# This target also builds dependency information as a side effect
# of the build.  Note that it doesn't declare that it builds the
# dependencies, and the "-include" command allows the files to
# be absent, so this setup will avoid premature compilation.
#
$(archdir)/%.o: %.c mkdir[$(archdir)]
	$(ECHO_TARGET)
	@echo $(CC) $(C_ALL_FLAGS) -c -o $(archdir)/$*.o $<
	@$(CC) $(C_WARN_FLAGS) $(C_ALL_FLAGS) -c -o $@ \
	    -MMD -MF $(archdir)/$*-depend.mk $<

#
# build: --Convenience target to build one C file.
#
build[%.c]:   $(archdir)/%.o; $(ECHO_TARGET)

#
# %.h: --Rules for installing header files.
#
$(includedir)/%.h:	%.h;		$(INSTALL_FILE) $? $@

#
# build: --c-specific customisations for the "build" target.
#
pre-build:	c-src-var-defined
build:	$(C_OBJ) $(C_MAIN)

#
# c-src-var-defined: --Test if "enough" of the C SRC variables are defined
#
c-src-var-defined:
	$(ECHO_TARGET)
	@test -n "$(C_SRC)" -o -n "$(H_SRC)" || \
	    { $(VAR_UNDEFINED) "C_SRC or H_SRC"; }

#
# clean: --c-specific customisations for the "clean" target.
#
clean:	c-clean
.PHONY:	c-clean
c-clean:
	$(ECHO_TARGET)
	$(RM) $(archdir)/*.o $(C_MAIN)

#
# tidy: --c-specific customisations for the "tidy" target.
#
tidy:	c-tidy
.PHONY:	c-tidy
c-tidy:
	$(ECHO_TARGET)
	INDENT_PROFILE=$(DEVKIT_HOME)/etc/.indent.pro $(INDENT) $(H_SRC) $(C_SRC)
#
# c-toc: --Build the table-of-contents for C-ish files.
#
.PHONY: c-toc
toc:	c-toc
c-toc:
	$(ECHO_TARGET)
	mk-toc $(H_SRC) $(C_SRC)

#
# c-src: --c-specific customisations for the "src" target.
#
src:	c-src
.PHONY:	c-src
c-src:
	$(ECHO_TARGET)
	@mk-filelist -qn C_SRC *.c
	@mk-filelist -qn C_MAIN_SRC \
		$$(grep -l '^ *int *main(' *.c 2>/dev/null)
	@mk-filelist -qn H_SRC *.h

#
# tags: --Build vi, emacs tags files.
#
.PHONY: c-tags
tags:	c-tags
c-tags:
	$(ECHO_TARGET)
	ctags 	$(H_SRC) $(C_SRC) && \
	etags	$(H_SRC) $(C_SRC); true

#
# todo: --Report unfinished work (identified by keyword comments)
#
.PHONY: c-todo
todo:	c-todo
c-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(H_SRC) $(C_SRC) /dev/null || true
