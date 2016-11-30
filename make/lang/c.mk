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

C_MAIN_RGX = '^[ \t]*int[ \t][ \t]*main[ \t]*('

ifdef AUTOSRC
    LOCAL_C_MAIN_SRC := $(shell grep -l $(C_MAIN_RGX) *.c 2>/dev/null)
    LOCAL_C_SRC := $(wildcard *.c)
    LOCAL_H_SRC := $(wildcard *.h)

    C_SRC ?= $(LOCAL_C_SRC)
    C_MAIN_SRC ?= $(LOCAL_C_MAIN_SRC)
    H_SRC ?= $(LOCAL_H_SRC)
endif

#
# Include any dependency information that's available.
#
-include $(C_SRC:%.c=$(archdir)/%.d)

C_MAIN_OBJ = $(C_MAIN_SRC:%.c=$(archdir)/%.o)
C_OBJ	= $(filter-out $(C_MAIN_OBJ),$(C_SRC:%.c=$(archdir)/%.o))
C_SHARED_OBJ	= $(filter-out $(C_MAIN_OBJ),$(C_SRC:%.c=$(archdir)/%.s.o))
C_MAIN	= $(C_MAIN_SRC:%.c=$(archdir)/%)
.PRECIOUS: $(C_MAIN_OBJ)

C_DEFS	= $(OS.C_DEFS) $(ARCH.C_DEFS)\
    $(PROJECT.C_DEFS) $(LOCAL.C_DEFS) $(TARGET.C_DEFS)

C_FLAGS = $(OS.CFLAGS) $(ARCH.CFLAGS) \
    $(PROJECT.CFLAGS) $(LOCAL.CFLAGS) $(TARGET.CFLAGS) $(CFLAGS)

C_WARN_FLAGS = $(OS.C_WARN_FLAGS) $(ARCH.C_WARN_FLAGS) \
    $(PROJECT.C_WARN_FLAGS) $(LOCAL.C_WARN_FLAGS) $(TARGET.C_WARN_FLAGS)

C_CPPFLAGS = $(CPPFLAGS) \
    $(TARGET.C_CPPFLAGS) $(LOCAL.C_CPPFLAGS) \
    $(LIB_PATH:%=-I%/include) $(LIB_ROOT:%=-I%/include) \
    $(PROJECT.C_CPPFLAGS) $(ARCH.C_CPPFLAGS) $(OS.C_CPPFLAGS) \
    -I. -I$(includedir)

C_SHARED_FLAGS = $(OS.C_SHARED_FLAGS) $(ARCH.C_SHARED_FLAGS) \
    $(PROJECT.C_SHARED_FLAGS) $(LOCAL.C_SHARED_FLAGS) $(TARGET.C_SHARED_FLAGS)

C_ALL_FLAGS = $(C_CPPFLAGS) $(C_DEFS) $(C_FLAGS)

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
# be absent, so this setup will avoid premature compilation.
#
$(archdir)/%.o: %.c | mkdir[$(archdir)]
	$(ECHO_TARGET)
	@echo $(CC) $(C_ALL_FLAGS) -c -o $@ $<
	@$(CC) $(C_WARN_FLAGS) $(C_ALL_FLAGS) -c -o $@ $<
#
# archdir/%.o: --Compile a generated C file into the arch sub-directory.
#
$(gendir)/%.o: $(archdir)/%.c
	$(ECHO_TARGET)
	$(MKDIR) $(@D)
	@echo $(CC) $(C_ALL_FLAGS) -c -o $@ $<
	@$(CC) $(C_WARN_FLAGS) $(C_ALL_FLAGS) -c -o $@ $<

#
# %.s.o: --Compile a C file into Position Independent Code (PIC).
#
# Remarks:
# This is a repeat of the static build rules, but for shared libraries.
#
$(archdir)/%.s.o: %.c | mkdir[$(archdir)]
	$(ECHO_TARGET)
	@echo $(CC) $(C_ALL_FLAGS)  $(C_SHARED_FLAGS) -c -o $@ $<
	@$(CC) $(C_WARN_FLAGS) $(C_ALL_FLAGS) $(C_SHARED_FLAGS) -c -o $@ $<
#
# archdir/%.s.o: --Compile a generated C file into PIC.
#
$(archdir)/%.s.o: $(gendir)/%.c | mkdir[$(archdir)]
	$(ECHO_TARGET)
	@echo $(CC) $(C_ALL_FLAGS) $(C_SHARED_FLAGS) -c -o $@ $<
	@$(CC) $(C_WARN_FLAGS) $(C_ALL_FLAGS) $(C_SHARED_FLAGS) -c -o $@ $<

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
# build: --Build the C objects and executables.
#
build:	build-c
build-c:	$(C_OBJ) $(C_MAIN_OBJ) $(C_MAIN); $(ECHO_TARGET)
$(C_OBJ) $(C_MAIN_OBJ) $(C_MAIN):	| build-subdirs

build-shared: build-c-shared
build-c-shared: $(C_SHARED_OBJ); $(ECHO_TARGET)

#
# build[%]: --Build a C file's related object.
#
build[%.c]:   $(archdir)/%.o; $(ECHO_TARGET)

#
# install: --Install "C" programs.
#
# Remarks:
# The install (and uninstall) target is not invoked by default,
# it must be added as a dependent of the "install" target.
#
install-c:	$(C_MAIN:$(archdir)/%=$(bindir)/%); $(ECHO_TARGET)
install-strip-c:	install-strip-file[$(C_MAIN:$(archdir)/%=$(bindir)/%)]
	$(ECHO_TARGET)

#
# uninstall: --Uninstall "C" programs.
#
uninstall-c:	src-var-defined[C_MAIN]
	$(ECHO_TARGET)
	$(RM) $(C_MAIN:$(archdir)/%=$(bindir)/%)
	$(RMDIR) -p $(bindir) 2>/dev/null || true

#
# clean: --Remove objects and executables created from C files.
#
clean:	clean-c
clean-c:
	$(ECHO_TARGET)
	$(RM) $(C_MAIN) $(C_MAIN_OBJ) $(C_MAIN_OBJ:%.o=%.d) $(C_MAIN_OBJ:%.o=%.map) $(C_OBJ) $(C_OBJ:%.o=%.d) $(C_SHARED_OBJ)  $(C_SHARED_OBJ:%.o=%.d)

#
# tidy: --Reformat C files consistently.
#
C_INDENT ?= INDENT_PROFILE=$(DEVKIT_HOME)/etc/.indent.pro indent
C_INDENT_FLAGS = $(OS.C_INDENT_FLAGS) $(ARCH.C_INDENT_FLAGS) \
    $(PROJECT.C_INDENT_FLAGS) $(LOCAL.C_INDENT_FLAGS) $(TARGET.C_INDENT_FLAGS)
tidy:	tidy-c
tidy-c:	c-src-defined
	$(ECHO_TARGET)
	$(C_INDENT) $(C_INDENT_FLAGS) $(H_SRC) $(C_SRC)
#
# lint: --Perform static analysis for C files.
#
C_LINT ?= cppcheck --quiet --std=c11 --template=gcc --enable=style,warning,performance,portability,information $(C_CPPFLAGS)
C_LINT_FLAGS = $(OS.C_LINT_FLAGS) $(ARCH.C_LINT_FLAGS) \
    $(PROJECT.C_LINT_FLAGS) $(LOCAL.C_LINT_FLAGS) $(TARGET.C_LINT_FLAGS)
lint:	lint-c
lint-c:
	$(ECHO_TARGET)
	$(C_LINT) $(C_LINT_FLAGS) $(H_SRC) $(C_SRC)
#
# toc: --Build the table-of-contents for C files.
#
toc:	toc-c
toc-c:	c-src-defined
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
            $$(grep -l $(C_MAIN_RGX) *.c 2>/dev/null)
	@mk-filelist -qn H_SRC *.h

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
	@$(GREP) $(TODO_PATTERN) $(H_SRC) $(C_SRC) /dev/null || true
