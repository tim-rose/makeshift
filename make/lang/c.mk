#
# C.MK --Rules for building C objects and programs.
#
# Contents:
# build()             --c-specific customisations for the "build" target.
# c-src-var-defined() --Test if "enough" of the C SRC variables are defined
# clean()             --c-specific customisations for the "clean" target.
# tidy()              --c-specific customisations for the "tidy" target.
# c-toc()             --Build the table-of-contents for C-ish files.
# c-src()             --c-specific customisations for the "src" target.
# tags()              --Build vi, emacs tags files.
# todo()              --Report unfinished work (identified by keyword comments)
# main:               --rules for building executables from a file containing "main()".
# build:              --c-specific customisations for the "build" target.
# c-src-var-defined:  --Test if "enough" of the C SRC variables are defined
# clean:              --c-specific customisations for the "clean" target.
# tidy:               --c-specific customisations for the "tidy" target.
# c-toc:              --Build the table-of-contents for C-ish files.
# c-src:              --c-specific customisations for the "src" target.
# tags:               --Build vi, emacs tags files.
# todo:               --Report unfinished work (identified by keyword comments)
# %.o()              --Compile a C file into an arch-specific sub-directory.
# %.h()              --Rules for installing header files.
# build()            --c-specific customisations for the "build" target.
# c-src-var-defined() --Test if "enough" of the C SRC variables are defined
# clean()            --c-specific customisations for the "clean" target.
# tidy()             --c-specific customisations for the "tidy" target.
# c-toc()            --Build the table-of-contents for C-ish files.
# c-src()            --c-specific customisations for the "src" target.
# tags()             --Build vi, emacs tags files.
# todo()             --Report unfinished work (identified by keyword comments)
#
-include $(C_SRC:%.c=$(archdir)/%-depend.mk)

C_DEFS	= $(C_OS_DEFS) $(C_ARCH_DEFS) -D__$(OS)__ -D__$(ARCH)__
C_WARN_FLAGS	= -O -pedantic -Wall -Wmissing-prototypes \
	-Wmissing-declarations 	-Wimplicit -Wpointer-arith \
	-Wwrite-strings -Waggregate-return -Wnested-externs \
	-Wcast-align -Wshadow -Wstrict-prototypes -Wredundant-decls \
	-Wuninitialized -Wunused-parameter
C_VIS_CFLAGS	= -std=c99 $(C_DEFS) $(C_OS_FLAGS) $(C_ARCH_FLAGS) $(CFLAGS)
C_ALL_CFLAGS	= $(C_VIS_CFLAGS) $(C_WARN_FLAGS)

CPPFLAGS 	= -I. -I$(includedir) -I$(DEVKIT_HOME)/include
LDFLAGS		= -L$(libdir) $(CFLAGS)

C_OBJ	= $(C_SRC:%.c=$(archdir)/%.o)
C_MAIN	= $(C_MAIN_SRC:%.c=$(archdir)/%)

#
# main: --rules for building executables from a file containing "main()".
#
$(archdir)/%: %.c $(archdir)/%.o
	@echo $(CC) $(CPPFLAGS) $(C_VIS_CFLAGS) $(LDFLAGS) $(archdir)/$*.o \
		$(LOADLIBES) $(LDLIBS)
	@$(CC) -o $@ $(C_ALL_CFLAGS) $(LDFLAGS) $(archdir)/$*.o \
		$(LOADLIBES) $(LDLIBS)

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
	@$(ECHO) "++ make[$@]@$$PWD"
	@echo $(CC) $(CPPFLAGS) $(C_VIS_CFLAGS) -c -o $(archdir)/$*.o $<
	@$(CC) $(CPPFLAGS) $(C_ALL_CFLAGS) -c -o $@ \
		-MMD -MF $(archdir)/$*-depend.mk $<

#
# %.h: --Rules for installing header files.
#
$(includedir)/%.h:	%.h;		$(INSTALL_DATA) $? $@

#
# build: --c-specific customisations for the "build" target.
#
pre-build:	c-src-var-defined
build:	$(C_OBJ) $(C_MAIN)

#
# c-src-var-defined: --Test if "enough" of the C SRC variables are defined
#
c-src-var-defined:
	@test -n "$(C_SRC)" -o -n "$(H_SRC)" || \
	    { $(VAR_UNDEFINED) "C_SRC or H_SRC"; }

#
# clean: --c-specific customisations for the "clean" target.
#
clean:	c-clean
.PHONY:	c-clean
c-clean:
	@$(ECHO) "++ make[$@]@$$PWD"
	$(RM) $(archdir)/*.o $(C_MAIN)

#
# tidy: --c-specific customisations for the "tidy" target.
#
tidy:	c-tidy
.PHONY:	c-tidy
c-tidy:
	@$(ECHO) "++ make[$@]@$$PWD"
	INDENT_PROFILE=$(DEVKIT_HOME)/etc/.indent.pro indent $(H_SRC) $(C_SRC)
#
# c-toc: --Build the table-of-contents for C-ish files.
#
.PHONY: c-toc
toc:	c-toc
c-toc:
	@$(ECHO) "++ make[$@]@$$PWD"
	mk-toc $(H_SRC) $(C_SRC)

#
# c-src: --c-specific customisations for the "src" target.
#
src:	c-src
.PHONY:	c-src
c-src:	
	@$(ECHO) "++ make[$@]@$$PWD"
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
	@$(ECHO) "++ make[$@]@$$PWD"
	ctags 	$(H_SRC) $(C_SRC) && \
	etags	$(H_SRC) $(C_SRC); true

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: c-todo
todo:	c-todo
c-todo:
	@$(ECHO) "++ make[$@]@$$PWD"
	@$(GREP) -e TODO -e FIXME -e REVISIT $(H_SRC) $(C_SRC) /dev/null || true
