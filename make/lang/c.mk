#
# C.MK --Rules for building C objects and programs.
#
# Contents:
# c-src-defined: --Test that the C SRC variable(s) are set.
# %.o:           --Compile a C file into an arch-specific sub-directory.
# archdir/%.o:   --Compile a generated C file into the arch sub-directory.
# %.s.o:         --Compile a C file into Position Independent Code (PIC).
# archdir/%.s.o: --Compile a generated C file into PIC.
# %.h:           --Install a C header (.h) file.
# %.c.gcov:      --Build a text-format coverage report.
# +c-defines:    --Print a list of predefined macros for the "C" language.
# build:         --Build the C objects and executables.
# build[%]:      --Build a C file's related object.
# install:       --Install "C" programs.
# uninstall:     --Uninstall "C" programs.
# clean:         --Remove objects and executables created from C files.
# tidy:          --Reformat C files consistently.
# lint:          --Perform static analysis for C files.
# toc:           --Build the table-of-contents for C files.
# src:           --Update the C_SRC, H_SRC, C_MAIN_SRC macros.
# tags:          --Build vi, emacs tags files.
# todo:          --Report "unfinished work" comments in C files.
# +version:      --Report details of tools used by C.
#
# Remarks:
# The "lang/c" module provides support for the "C" programming language.
# It requires some of the following variables to be defined:
#
#  * H_SRC	--C header files
#  * C_SRC	--C source files
#  * C_MAIN_SRC	--C source files that define a main() function.
#
# TODO: cleanup cppcheck dump files!
#

.PHONY: $(recursive-targets:%=%-c)

C_MAIN_RGX = '^[ \t]*int[ \t][ \t]*main[ \t]*('

ifdef autosrc
    LOCAL_C_SRC := $(wildcard *.c)
    LOCAL_H_SRC := $(wildcard *.h)
    LOCAL_C_MAIN_SRC := $(shell grep -l $(C_MAIN_RGX) *.c 2>/dev/null)

    C_SRC ?= $(LOCAL_C_SRC)
    H_SRC ?= $(LOCAL_H_SRC)
    C_MAIN_SRC ?= $(LOCAL_C_MAIN_SRC)
    C_LIB_SRC ?= $(LOCAL_C_LIB_SRC)
endif

# C_LIB_SRC: all the "doesn't contain main()" files...
C_LIB_SRC := $(filter-out $(C_MAIN_SRC),$(C_SRC))

#
# Include any dependency information that's available.
#
-include $(C_SRC:%.c=$(archdir)/%.d)

C_MAIN_OBJ = $(C_MAIN_SRC:%.c=$(archdir)/%.$(o))
C_LIB_OBJ = $(C_LIB_SRC:%.c=$(archdir)/%.$(o))
C_OBJ	= $(C_MAIN_OBJ) $(C_LIB_OBJ)
C_MAIN_PIC_OBJ = $(C_MAIN_SRC:%.c=$(archdir)/%.$(s.o))
C_LIB_PIC_OBJ = $(C_LIB_SRC:%.c=$(archdir)/%.$(s.o))
C_PIC_OBJ	= $(C_MAIN_PIC_OBJ) $(C_LIB_PIC_OBJ)

.PRECIOUS: $(C_MAIN_OBJ) $(C_MAIN_PIC_OBJ)

C_MAIN = $(C_MAIN_OBJ:%.$(o)=%)

C_DEFS	= $(OS.C_DEFS) $(ARCH.C_DEFS)\
    $(PROJECT.C_DEFS) $(LOCAL.C_DEFS) $(TARGET.C_DEFS)

C_FLAGS = $(OS.CFLAGS) $(ARCH.CFLAGS) \
    $(PROJECT.CFLAGS) $(LOCAL.CFLAGS) $(TARGET.CFLAGS) $(CFLAGS)

C_WARN_FLAGS = $(OS.C_WARN_FLAGS) $(ARCH.C_WARN_FLAGS) \
    $(PROJECT.C_WARN_FLAGS) $(LOCAL.C_WARN_FLAGS) $(TARGET.C_WARN_FLAGS)

C_CPPFLAGS = $(CPPFLAGS) \
    $(TARGET.C_CPPFLAGS) $(LOCAL.C_CPPFLAGS) \
    $(BUILD_PATH:%=-I%/include) $(LIB_ROOT:%=-I%/include) \
    $(PROJECT.C_CPPFLAGS) $(ARCH.C_CPPFLAGS) $(OS.C_CPPFLAGS) \
    -I. -I$(gendir)

C_SHARED_FLAGS = $(OS.C_SHARED_FLAGS) $(ARCH.C_SHARED_FLAGS) \
    $(PROJECT.C_SHARED_FLAGS) $(LOCAL.C_SHARED_FLAGS) $(TARGET.C_SHARED_FLAGS)

C_ALL_FLAGS = $(C_WARN_FLAGS) $(C_CPPFLAGS) $(C_DEFS) $(C_FLAGS)

#
# c-src-defined: --Test that the C SRC variable(s) are set.
#
c-src-defined:
	@if [ ! '$(C_SRC)$(H_SRC)' ]; then \
	    printf $(VAR_UNDEF) "H_SRC and C_SRC"; \
	    echo 'run "make src" to define it'; \
	    false; \
	fi >&2

#
# %.o: --Compile a C file into an arch-specific sub-directory.
#
# Remarks:
# This target also builds dependency information as a side effect
# of the build.  Note that it doesn't declare that it builds the
# dependencies, and the "-include" command allows the files to
# be absent, to avoid premature compilation.
#
$(archdir)/%.$(o): %.c | $(archdir)
	$(ECHO_TARGET)
	$(CROSS_COMPILE)$(CC) $(C_ALL_FLAGS) -c -o $@ $(abspath $<)
#
# archdir/%.o: --Compile a generated C file into the arch sub-directory.
#
$(archdir)/%.$(o): $(gendir)/%.c | $(archdir)
	$(ECHO_TARGET)
	$(CROSS_COMPILE)$(CC) $(C_ALL_FLAGS) -c -o $@ $(abspath $<)

#
# %.s.o: --Compile a C file into Position Independent Code (PIC).
#
# Remarks:
# This is a repeat of the static build rules, but for shared libraries.
#
$(archdir)/%.$(s.o): %.c | $(archdir)
	$(ECHO_TARGET)
	$(CROSS_COMPILE)$(CC) $(C_ALL_FLAGS) $(C_SHARED_FLAGS) -c -o $@ $(abspath $<)
#
# archdir/%.s.o: --Compile a generated C file into PIC.
#
$(archdir)/%.$(s.o): $(gendir)/%.c
	$(ECHO_TARGET)
	$(CROSS_COMPILE)$(CC) $(C_ALL_FLAGS) $(C_SHARED_FLAGS) -c -o $@ $(abspath $<)

#
# %.h: --Install a C header (.h) file.
#
$(includedir)/%.h:	%.h
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@

$(includedir)/%.h:	$(gendir)/%.h
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@

#
# %.c.gcov: --Build a text-format coverage report.
#
# Remarks:
# The gcov tool outputs some progress information, which is
# mostly filtered out.
#
%.c.gcov:	$(archdir)/%.gcda
	gcov -o $(archdir) $*.c | sed -ne '/^Lines/s/.*:/gcov $*.c: /p'

#
# +c-defines: --Print a list of predefined macros for the "C" language.
#
# Remarks:
# This target uses gcc-specific compiler options, so it may not work
# on your compiler...
#
+c-defines:
	$(Q)touch ..c;  $(CROSS_COMPILE)$(CC) -E -dM ..c; $(RM) ..c

#
# build: --Build the C objects and executables.
#
build:	build-c
build-c:	$(C_MAIN)
	$(ECHO_TARGET)

#
# build any subdirectories before trying to compile stuff;
# library subdirectories may install include files needed
# for compilation.
#
$(C_OBJ) $(C_MAIN_OBJ) $(C_MAIN):	| build-subdirs
$(C_PIC_OBJ) $(C_MAIN_PIC_OBJ):	| build-subdirs

#
# build[%]: --Build a C file's related object.
#
build[%.c]:   $(archdir)/%.$(o); $(ECHO_TARGET)

#
# install: --Install "C" programs.
#
# Remarks:
# The install (and uninstall) target is not invoked by default,
# it must be added as a dependent of the "install" target.
#
install-c:	$(C_MAIN:$(archdir)/%=$(bindir)/%)
	$(ECHO_TARGET)
install-strip-c:	install-strip-file[$(C_MAIN:$(archdir)/%=$(bindir)/%)]
	$(ECHO_TARGET)

#
# uninstall: --Uninstall "C" programs.
#
uninstall-c:
	$(ECHO_TARGET)
	$(RM) $(C_MAIN:$(archdir)/%=$(bindir)/%)
	$(RMDIR) $(bindir)

#
# clean: --Remove objects and executables created from C files.
#
clean:	clean-c
clean-c:
	$(ECHO_TARGET)
	$(RM) $(C_MAIN) $(C_MAIN:%=%.map) $(C_OBJ) $(C_OBJ:%.$(o)=%.[sd]) $(C_PIC_OBJ)

#
# tidy: --Reformat C files consistently.
#
C_TIDY_CMD ?= clang-format
C_TIDY_CMD_FLAGS ?= -i --style=file
C_TIDY_FLAGS = $(C_TIDY_CMD_FLAGS) $(OS.C_TIDY_FLAGS) $(ARCH.C_TIDY_FLAGS) \
    $(PROJECT.C_TIDY_FLAGS) $(LOCAL.C_TIDY_FLAGS) $(TARGET.C_TIDY_FLAGS)
tidy:	tidy-c
tidy-c:	c-src-defined
	$(ECHO_TARGET)
	$(C_TIDY_CMD) $(C_TIDY_FLAGS) $(H_SRC) $(C_SRC)
tidy[%.c]:
	$(ECHO_TARGET)
	$(C_TIDY_CMD) $(C_TIDY_FLAGS) $*.c
tidy[%.h]:
	$(ECHO_TARGET)
	$(C_TIDY_CMD) $(C_TIDY_FLAGS) $*.h

#
# lint: --Perform static analysis for C files.
#
# Remarks:
# Hmmm, this is starting to get a bit messy.  I want to be able to
# run several different linters independently.
#
C_LINT_CMD ?= clang-tidy
CPPCHECK_FLAGS ?= --quiet --std=c11 --template=gcc \
    --enable=style,warning,performance,portability,information \
    --suppress=missingIncludeSystem $(C_CPPFLAGS)

lint:	$(C_LINT_CMD:%=lint-c-%)
lint-c-cppcheck: c-src-defined
	$(ECHO_TARGET)
	cppcheck $(CPPCHECK_FLAGS) $(abspath $(C_SRC))
lint-cppcheck[%.c]:
	$(ECHO_TARGET)
	cppcheck $(CPPCHECK_FLAGS) $(abspath $*.c)
lint-cppcheck[%.h]:
	$(ECHO_TARGET)
	cppcheck $(CPPCHECK_FLAGS) $(abspath $*.h)

CLANG_TIDY_FLAGS ?= --fix
CLANG_EXTRA_FLAGS = $(C_CPPFLAGS) $(C_DEFS) $(C_FLAGS)

lint-c-clang-tidy: c-src-defined
	$(ECHO_TARGET)
	clang-tidy $(CLANG_TIDY_FLAGS) $(CLANG_EXTRA_FLAGS:%=-extra-arg=%) $(abspath $(C_SRC))
lint-clang-tidy[%.c]:
	$(ECHO_TARGET)
	clang-tidy $(CLANG_TIDY_FLAGS) $(CLANG_EXTRA_FLAGS:%=-extra-arg=%) $(abspath $*.c)
lint-clang-tidy[%.h]:
	$(ECHO_TARGET)
	clang-tidy $(CLANG_TIDY_FLAGS) $(CLANG_EXTRA_FLAGS:%=-extra-arg=%) $(abspath $*.h)

#
# toc: --Build the table-of-contents for C files.
#
toc:	toc-c
toc-c:	c-src-defined
	$(ECHO_TARGET)
	mk-toc $(H_SRC) $(C_SRC)
toc[%.c]:
	$(ECHO_TARGET)
	mk-toc $*.c
toc[%.h]:
	$(ECHO_TARGET)
	mk-toc $*.h

#
# src: --Update the C_SRC, H_SRC, C_MAIN_SRC macros.
#
src:	src-c
src-c:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qn C_SRC $(WILDCARD).c
	$(Q)mk-filelist -f $(MAKEFILE) -qn C_MAIN_SRC \
            $$(grep -l $(C_MAIN_RGX) $(WILDCARD).c 2>/dev/null)
	$(Q)mk-filelist -f $(MAKEFILE) -qn H_SRC $(WILDCARD).h

#
# tags: --Build vi, emacs tags files.
#
tags:	tags-c
tags-c:	c-src-defined
	$(ECHO_TARGET)
	-ctags $(H_SRC) $(C_SRC) && etags $(H_SRC) $(C_SRC)

#
# todo: --Report "unfinished work" comments in C files.
#
todo:	todo-c
todo-c:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(H_SRC) $(C_SRC) /dev/null ||:

#
# +version: --Report details of tools used by C.
#
+version: cmd-version[$(CROSS_COMPILE)$(CC)] cmd-version[$(C_TIDY_CMD)] \
    cmd-version[$(C_LINT_CMD)]
