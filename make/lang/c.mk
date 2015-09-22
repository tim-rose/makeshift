#
# C.MK --Rules for building C objects and programs.
#
# Contents:
# %.o:               --Compile a C file into an arch-specific sub-directory.
# archdir/%.o:       --Compile a generated C file into the arch sub-directory.
# build[%]:          --Build a C file's related object.
# %.h:               --Install a C header (.h) file.
# %.c.gcov:          --Build a text-format coverage report.
# +c-defines:        --Print a list of predefined macros for the "C" language.
# build:             --c-specific customisations for the "build" target.
# c-src-var-defined: --Test if "enough" of the C SRC variables are defined
# clean:             --Remove objects and executables created from C files.
# tidy:              --Reformat C files consistently.
# toc:               --Build the table-of-contents for C files.
# src:               --Update the C_SRC, H_SRC, C_MAIN_SRC macros.
# tags:              --Build vi, emacs tags files.
# todo:              --Report "unfinished work" comments in C files.
#
# Remarks:
# The "lang/c" module provides support for the "C" programming language.
# It requires some of the following variables to be defined:
#
#  * H_SRC	--C header files
#  * C_SRC	--C source files
#  * C_MAIN_SRC	--C source files that define a main() function.
#

.PHONY: $(recursive-targets:%=%-c)

#
# Include any dependency information that's available.
#
-include $(C_SRC:%.c=$(archdir)/%.d)

C_OBJ	= $(C_SRC:%.c=$(archdir)/%.o)
C_MAIN_OBJ = $(C_MAIN_SRC:%.c=$(archdir)/%.o)
C_MAIN	= $(C_MAIN_SRC:%.c=$(archdir)/%)

C_DEFS	= $(OS.C_DEFS) $(ARCH.C_DEFS)\
	$(PROJECT.C_DEFS) $(LOCAL.C_DEFS) $(TARGET.C_DEFS)

C_FLAGS = $(OS.CFLAGS) $(ARCH.CFLAGS) \
	$(PROJECT.CFLAGS) $(LOCAL.CFLAGS) $(TARGET.CFLAGS) $(CFLAGS)

C_WARN_FLAGS = $(OS.C_WARN_FLAGS) $(ARCH.C_WARN_FLAGS) \
        $(PROJECT.C_WARN_FLAGS) $(LOCAL.C_WARN_FLAGS) $(TARGET.C_WARN_FLAGS)

C_CPPFLAGS = $(CPPFLAGS) \
	$(TARGET.C_CPPFLAGS) $(LOCAL.C_CPPFLAGS) $(PROJECT.C_CPPFLAGS) \
	$(ARCH.C_CPPFLAGS) $(OS.C_CPPFLAGS) \
        -I$(includedir)

C_ALL_FLAGS = $(C_CPPFLAGS) $(C_DEFS) $(C_FLAGS)

#
# %.o: --Compile a C file into an arch-specific sub-directory.
#
# Remarks:
# This target also builds dependency information as a side effect
# of the build.  Note that it doesn't declare that it builds the
# dependencies, and the "-include" command allows the files to
# be absent, so this setup will avoid premature compilation.
#
$(archdir)/%.o: %.c
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	@echo $(CC) $(C_ALL_FLAGS) -c -o $@ $<
	@$(CC) $(C_WARN_FLAGS) $(C_ALL_FLAGS) -c -o $@ $<
#
# archdir/%.o: --Compile a generated C file into the arch sub-directory.
#
$(archdir)/%.o: $(archdir)/%.c
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	@echo $(CC) $(C_ALL_FLAGS) -c -o $@ $<
	@$(CC) $(C_WARN_FLAGS) $(C_ALL_FLAGS) -c -o $@ $<

#
# build[%]: --Build a C file's related object.
#
build[%.c]:   $(archdir)/%.o; $(ECHO_TARGET)

#
# %.h: --Install a C header (.h) file.
#
$(includedir)/%.h:	%.h;		$(INSTALL_FILE) $? $@
$(includedir)/%.h:	$(archdir)/%.h;	$(INSTALL_FILE) $? $@

#
# %.c.gcov: --Build a text-format coverage report.
#
# Remarks:
# The gcov tool outputs some progress information, which is
# mostly filtered out.
#
%.c.gcov:	$(archdir)/%.gcda
	@echo gcov -o $(archdir) $*.c
	@gcov -o $(archdir) $*.c | sed -ne '/^Lines/s/.*:/gcov $*.c: /p'

#
# +c-defines: --Print a list of predefined macros for the "C" language.
#
# Remarks:
# This target uses gcc-specific compiler options, so it may not work
# on your compiler...
#
+c-defines:
	@touch ..c;  $(CC) -E -dM ..c; $(RM) ..c

#
# build: --c-specific customisations for the "build" target.
#
build:	$(C_OBJ) $(C_MAIN)
$(C_OBJ) $(C_MAIN): pre-build

#
# c-src-var-defined: --Test if "enough" of the C SRC variables are defined
#
c-src-var-defined:
	@if [ -z '$(C_SRC)$(H_SRC)' ]; then \
	    printf $(VAR_UNDEF) "C_SRC, H_SRC"; \
	    echo 'run "make src" to define them'; \
	    false; \
	fi >&2

#
# clean: --Remove objects and executables created from C files.
#
clean:	clean-c
clean-c:
	$(ECHO_TARGET)
	$(RM) $(C_OBJ) $(C_MAIN)

#
# tidy: --Reformat C files consistently.
#
tidy:	tidy-c
tidy-c:
	$(ECHO_TARGET)
	INDENT_PROFILE=$(DEVKIT_HOME)/etc/.indent.pro $(INDENT) $(H_SRC) $(C_SRC)
#
# toc: --Build the table-of-contents for C files.
#
toc:	toc-c
toc-c:
	$(ECHO_TARGET)
	mk-toc $(H_SRC) $(C_SRC)

#
# src: --Update the C_SRC, H_SRC, C_MAIN_SRC macros.
#
src:	src-c
src-c:
	$(ECHO_TARGET)
	@mk-filelist -qn C_SRC *.c
	@mk-filelist -qn C_MAIN_SRC \
		$$(grep -l '^ *int *main(' *.c 2>/dev/null)
	@mk-filelist -qn H_SRC *.h

#
# tags: --Build vi, emacs tags files.
#
tags:	tags-c
tags-c:
	$(ECHO_TARGET)
	ctags 	$(H_SRC) $(C_SRC) && \
	etags	$(H_SRC) $(C_SRC); true

#
# todo: --Report "unfinished work" comments in C files.
#
todo:	todo-c
todo-c:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(H_SRC) $(C_SRC) /dev/null || true
