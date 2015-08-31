#
# C++.MK --Rules for building C++ objects and programs.
#
# Contents:
# %.o:    --Compile a C++ file into an arch-specific sub-directory.
# %.o:    --Compile an arch-specific C++ file into an arch-specific sub-directory.
# %.gcov: --Build a text-format coverage report.
# build:  --Build the C++ files (as defined by C++_SRC, C++_MAIN_SRC)
# clean:  --Remove objects and executables created from C++ files.
# tidy:   --Reformat C++ files consistently.
# toc:    --Build the table-of-contents for C++ files.
# src:    --Update the C++_SRC, H++_SRC, C++_MAIN_SRC macros.
# tags:   --Build vi, emacs tags files for C++ files.
# todo:   --Find "unfinished work" comments in C++ files.
#
# Remarks:
# The C++ module provides rules and targets for building software
# using the C++ language. C++ is a little unusual in that there is not
# standard file extension; the default is ".cc", but it can be set via
# the C++_SUFFIX macro.
#

#
# Include any dependency information that's available.
#
C++_SUFFIX ?= cc
H++_SUFFIX ?= h

C++	= $(CXX)
LD	= $(CXX)
LANG.LDFLAGS = -stdlib=libstdc++

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
        -I$(includedir)

C++_ALL_FLAGS = $(C++_CPPFLAGS) $(C++_DEFS) $(C++_FLAGS)

C++_LDLIBS = $(LOADLIBES) $(LDLIBS) \
	$(OS.LDLIBS) $(ARCH.LDLIBS) \
	$(PROJECT.LDLIBS) $(LOCAL.LDLIBS) $(TARGET.LDLIBS)

-include $(C++_SRC:%.$(C++_SUFFIX)=$(archdir)/%.d)
C++_OBJ  = $(C++_SRC:%.$(C++_SUFFIX)=$(archdir)/%.o)
C++_MAIN_OBJ = $(C++_MAIN_SRC:%.$(C++_SUFFIX)=$(archdir)/%.o)
C++_MAIN = $(C++_MAIN_SRC:%.$(C++_SUFFIX)=$(archdir)/%)

#
# %.o: --Compile a C++ file into an arch-specific sub-directory.
#
$(archdir)/%.o: %.$(C++_SUFFIX)
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	@echo $(C++) $(C++_ALL_FLAGS) -c -o $@ $<
	@$(C++) $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) -c -o $@ $<

#
# %.o: --Compile an arch-specific C++ file into an arch-specific sub-directory.
#
$(archdir)/%.o: $(archdir)/%.$(C++_SUFFIX)
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	@echo $(C++) $(C++_ALL_FLAGS) -c -o $@ $<
	@$(C++) $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) -c -o $@ $<
#
# build[%.c++]: --Build a C++ file's related object.
#
build[%.$(C++_SUFFIX)]:   $(archdir)/%.o; $(ECHO_TARGET)

#
# %.gcov: --Build a text-format coverage report.
#
%.$(C++_SUFFIX).gcov:	$(archdir)/%.gcda
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	@echo gcov -o $(archdir) $*.$(C++_SUFFIX)
	@gcov -o $(archdir) $*.$(C++_SUFFIX) | \
	    sed -ne '/^Lines/s/.*:/gcov $*.$(C++_SUFFIX): /p'

#
# %.h++: --Install a C++ header (.hpp) file.
#
$(includedir)/%.$(H++_SUFFIX):	%.$(H++_SUFFIX)
	$(INSTALL_FILE) $? $@
$(includedir)/%.$(H++_SUFFIX):	$(archdir)/%.$(H++_SUFFIX)
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
# build: --Build the C++ files (as defined by C++_SRC, C++_MAIN_SRC)
#
# Remarks:
# Note that C++_MAIN isn't built
#
build:	$(C++_OBJ) $(C++_MAIN)

#
# c++-src-var-defined: --Test if "enough" of the C++ SRC variables are defined
#
c++-src-var-defined:
	@if [ -z '$(C++_SRC)$(H++_SRC)' ]; then \
	    printf $(VAR_UNDEF) "C++_SRC, H++_SRC"; \
	    echo 'run "make src" to define them'; \
	    false; \
	fi >&2

#
# clean: --Remove objects and executables created from C++ files.
#
clean:	clean-c++
.PHONY:	clean-c++
clean-c++:
	$(ECHO_TARGET)
	$(RM) $(C++_OBJ) $(C++_MAIN)

#
# tidy: --Reformat C++ files consistently.
#
tidy:	tidy-c++
.PHONY:	tidy-c++
tidy-c++:
	$(ECHO_TARGET)
	INDENT_PROFILE=$(DEVKIT_HOME)/etc/.indent.pro indent $(H++_SRC) $(C++_SRC)
#
# toc: --Build the table-of-contents for C++ files.
#
.PHONY: toc-c++
toc:	toc-c++
toc-c++:
	$(ECHO_TARGET)
	mk-toc $(H++_SRC) $(C++_SRC)

#
# src: --Update the C++_SRC, H++_SRC, C++_MAIN_SRC macros.
#
# Remarks:
# Actually, for C++ this is a little involved, because we create
# SRC macros for every variety of suffix.
#
src:	src-c++
.PHONY:	src-c++
src-c++:
	$(ECHO_TARGET)
	@mk-filelist -qn C++_SRC *.$(C++_SUFFIX)
	@mk-filelist -qn C++_MAIN_SRC \
		$$(grep -l '^ *int *main(' *.$(C++_SUFFIX) 2>/dev/null)
	@mk-filelist -qn H++_SRC *.$(H++_SUFFIX)

#
# tags: --Build vi, emacs tags files for C++ files.
#
.PHONY: tags-c++
tags:	tags-c++
tags-c++:
	$(ECHO_TARGET)
	ctags 	$(H++_SRC) $(C++_SRC) && \
	etags	$(H++_SRC) $(C++_SRC); true

#
# todo: --Find "unfinished work" comments in C++ files.
#
.PHONY: todo-c++
todo:	todo-c++
todo-c++:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(H++_SRC) $(C++_SRC) /dev/null || true
