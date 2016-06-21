#
# C++.MK --Rules for building C++ objects and programs.
#
# Contents:
# %.o:         --Compile a C++ file into an arch-specific sub-directory.
# archdir/%.o: --Compile a generated C++ file into the arch sub-directory.
# %.gcov:      --Build a text-format coverage report.
# build:       --Compile the C++ files, and link any complete programs.
# install:     --Install "C++" programs.
# uninstall:   --Uninstall "C++" programs.
# clean:       --Remove objects and executables created from C++ files.
# tidy:        --Reformat C++ files consistently.
# lint:        --Perform static analysis for C++ files.
# toc:         --Build the table-of-contents for C++ files.
# src:         --Update the C++_SRC, H++_SRC, C++_MAIN_SRC macros.
# tags:        --Build vi, emacs tags files for C++ files.
# todo:        --Find "unfinished work" comments in C++ files.
#
# Remarks:
# The C++ module provides rules and targets for building software
# using the C++ language. C++ is a little unusual in that there isn't
# a standard file extension for the source and header files; the
# (devkit) default is ".cc", ".h", but it can be set via the
# C++_SUFFIX and H++_SUFFIX macros.
#
.PHONY: $(recursive-targets:%=%-c++)

C++_SUFFIX ?= cc
H++_SUFFIX ?= h
C++_MAIN_RGX = '^[ \t]*int[ \t][ \t]*main[ \t]*('

ifdef AUTOSRC
    LOCAL_C++_MAIN_SRC := $(shell grep -l $(C++_MAIN_RGX) *.$(C++_SUFFIX) 2>/dev/null)
    LOCAL_C++_SRC := $(wildcard *.$(C++_SUFFIX))
    LOCAL_H++_SRC := $(wildcard *.$(H++_SUFFIX))

    C++_SRC ?= $(LOCAL_C++_SRC)
    C++_MAIN_SRC ?= $(LOCAL_C++_MAIN_SRC)
    H++_SRC ?= $(LOCAL_H_SRC)
endif

#
# Include any dependency information that's available.
#
-include $(C++_SRC:%.$(C++_SUFFIX)=$(archdir)/%.d)

C++	= $(CXX)
LD	= $(CXX)

C++_DEFS = $(OS.C++_DEFS) $(ARCH.C++_DEFS)\
    $(PROJECT.C++_DEFS) $(LOCAL.C++_DEFS) $(TARGET.C++_DEFS) \

C++_FLAGS = $(OS.CXXFLAGS) $(ARCH.CXXFLAGS) \
    $(PROJECT.CXXFLAGS) $(LOCAL.CXXFLAGS) $(TARGET.CXXFLAGS) \
    $(CFLAGS) $(CXXFLAGS)

C++_WARN_FLAGS  = $(OS.C++_WARN_FLAGS) $(ARCH.C++_WARN_FLAGS) \
    $(PROJECT.C++_WARN_FLAGS) $(LOCAL.C++_WARN_FLAGS) \
    $(TARGET.C++_WARN_FLAGS)

C++_CPPFLAGS = $(CPPFLAGS) \
    $(TARGET.C++_CPPFLAGS) $(LOCAL.C++_CPPFLAGS) $(PROJECT.C++_CPPFLAGS) \
    $(ARCH.C++_CPPFLAGS) $(OS.C++_CPPFLAGS) \
    $(LIB_ROOT:%=-I%/include) $(LIB_PATH:%=-I%/include) \
    -I$(includedir)

C++_ALL_FLAGS = $(C++_CPPFLAGS) $(C++_DEFS) $(C++_FLAGS)

C++_MAIN_OBJ = $(C++_MAIN_SRC:%.$(C++_SUFFIX)=$(archdir)/%.o)
C++_OBJ  = $(filter-out $(C++_MAIN_OBJ),$(C++_SRC:%.$(C++_SUFFIX)=$(archdir)/%.o))
C++_MAIN = $(C++_MAIN_SRC:%.$(C++_SUFFIX)=$(archdir)/%)
.PRECIOUS: $(C++_MAIN_OBJ)

#
# c++-src-defined: --Test that the C++ SRC variable(s) are set.
#
c++-src-defined:
	@if [ ! '$(C++_SRC)$(H++_SRC)' ]; then \
	    printf $(VAR_UNDEF) "H++_SRC and C++_SRC"; \
	    echo 'run "make src" to define it'; \
	    false; \
	fi >&2

#
# %.o: --Compile a C++ file into an arch-specific sub-directory.
#
$(archdir)/%.o: %.$(C++_SUFFIX) | mkdir[$(archdir)]
	$(ECHO_TARGET)
	@echo $(C++) $(C++_ALL_FLAGS) -c -o $@ $<
	@$(C++) $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) -c -o $@ $<

#
# archdir/%.o: --Compile a generated C++ file into the arch sub-directory.
#
$(archdir)/%.o: $(archdir)/%.$(C++_SUFFIX) | mkdir[$(archdir)]
	$(ECHO_TARGET)
	@echo $(C++) $(C++_ALL_FLAGS) -c -o $@ $<
	@$(C++) $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) -c -o $@ $<
#
# build[%.c++]: --Build a C++ file's related object.
#
build[%.$(C++_SUFFIX)]:   $(archdir)/%.o; $(ECHO_TARGET)

#
# %.gcov: --Build a text-format coverage report.
#
%.$(C++_SUFFIX).gcov:	$(archdir)/%.gcda mkdir[$(archdir)]
	$(ECHO_TARGET)
	@echo gcov -o $(archdir) $*.$(C++_SUFFIX)
	@gcov -o $(archdir) $*.$(C++_SUFFIX) | \
            sed -ne '/^Lines/s/.*:/gcov $*.$(C++_SUFFIX): /p'

#
# %.h++: --Install a C++ header file.
#
$(includedir)/%.$(H++_SUFFIX):	%.$(H++_SUFFIX)
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@

$(includedir)/%.$(H++_SUFFIX):	$(archdir)/%.$(H++_SUFFIX) mkdir[$(archdir)]
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@

#
# +c++-defines: --Print a list of predefined macros for the "C++" language.
#
# Remarks:
# This target uses gcc-specific compiler options, so it may not work
# on your compiler...
#
+c++-defines:
	@touch ..$(C++_SUFFFIX); \
            $(C++) -E -dM ..$(C++_SUFFIX); \
            $(RM) ..$(C++_SUFFIX)

#
# build: --Compile the C++ files, and link any complete programs.
#
build:	build-c++
build-c++:	$(C++_OBJ) $(C++_MAIN_OBJ) $(C++_MAIN)
	$(ECHO_TARGET)

#
# install: --Install "C++" programs.
#
# Remarks:
# The install (and uninstall) target is not invoked by default,
# it must be added as a dependent of the "install" target.
#
install-c++:	$(C++_MAIN:$(archdir)/%=$(bindir)/%)
	$(ECHO_TARGET)

#
# uninstall: --Uninstall "C++" programs.
#
uninstall-c++: src-var-defined[C++_MAIN_SRC]
	$(ECHO_TARGET)
	$(RM) $(C++_MAIN:$(archdir)/%=$(bindir)/%)
	$(RMDIR) -p $(bindir) 2>/dev/null || true

#
# clean: --Remove objects and executables created from C++ files.
#
clean:	clean-c++
clean-c++:
	$(ECHO_TARGET)
	$(RM) $(C++_MAIN) $(C++_OBJ) $(C++_OBJ:%.o=%.d)

#
# tidy: --Reformat C++ files consistently.
#
C++_INDENT ?= INDENT_PROFILE=$(DEVKIT_HOME)/etc/.indent.pro indent
C++_INDENT_FLAGS = $(OS.C++_INDENT_FLAGS) $(ARCH.C++_INDENT_FLAGS) \
    $(PROJECT.C++_INDENT_FLAGS) $(LOCAL.C++_INDENT_FLAGS) $(TARGET.C++_INDENT_FLAGS)
tidy:	tidy-c++
tidy-c++:	c++-src-defined
	$(ECHO_TARGET)
	$(C++_INDENT) $(C++_INDENT_FLAGS) $(H++_SRC) $(C++_SRC)
#
# lint: --Perform static analysis for C++ files.
#
C++_LINT ?= cppcheck --quiet --std=c++11 --template=gcc --enable=style,warning,performance,portability,information $(C++_CPPFLAGS)
C++_LINT_FLAGS = $(OS.C++_LINT_FLAGS) $(ARCH.C++_LINT_FLAGS) \
    $(PROJECT.C++_LINT_FLAGS) $(LOCAL.C++_LINT_FLAGS) $(TARGET.C++_LINT_FLAGS)

lint:	lint-c++
lint-c++:	c++-src-defined
	$(ECHO_TARGET)
	$(C++_LINT) $(C++_LINT_FLAGS) $(H++_SRC) $(C++_SRC)

#
# toc: --Build the table-of-contents for C++ files.
#
toc:	toc-c++
toc-c++:	c++-src-defined
	$(ECHO_TARGET)
	mk-toc $(H++_SRC) $(C++_SRC)

#
# src: --Update the C++_SRC, H++_SRC, C++_MAIN_SRC macros.
#
src:	src-c++
src-c++:
	$(ECHO_TARGET)
	@mk-filelist -qn C++_SRC *.$(C++_SUFFIX)
	@mk-filelist -qn C++_MAIN_SRC \
            $$(grep -l $(C++_MAIN_RGX) *.$(C++_SUFFIX) 2>/dev/null)
	@mk-filelist -qn H++_SRC *.$(H++_SUFFIX)

#
# tags: --Build vi, emacs tags files for C++ files.
#
tags:	tags-c++
tags-c++:	c++-src-defined
	$(ECHO_TARGET)
	-ctags $(H++_SRC) $(C++_SRC) && etags $(H++_SRC) $(C++_SRC)

#
# todo: --Find "unfinished work" comments in C++ files.
#
todo:	todo-c++
todo-c++:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(H++_SRC) $(C++_SRC) /dev/null || true
