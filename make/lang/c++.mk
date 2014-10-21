#
# C++.MK --Rules for building C++ objects and programs.
#
# Contents:
# main:     --Build a program from a file that contains "main".
# %.o:      --Compile a C++ file into an arch-specific sub-directory.
# %.o:      --Compile an arch-specific C++ file into an arch-specific sub-directory.
# build[%]: --Build a C++ file's related object.
# %.hpp:    --Install a C++ header (.hpp) file.
# build:    --Build the C++ files (as defined by C++_SRC, C++_MAIN_SRC)
# clean:    --Remove objects and executables created from C++ files.
# tidy:     --Reformat C++ files consistently.
# toc:      --Build the table-of-contents for C++ files.
# src:      --Update the C++_SRC, H++_SRC, C++_MAIN_SRC macros.
# tags:     --Build vi, emacs tags files for C++ files.
# todo:     --Find "unfinished work" comments in C++ files.
#
# Remarks:
# The C++ module provides rules and targets for building software
# in using the C++ language.
#

#
# Include any dependency information that's available.
#
-include $(C++_SRC:%.cpp=$(archdir)/%-depend.mk)

#
# Generate coverage reports using gcov, lcov.
#
GCOV_FILES = $(C++_SRC:%.cpp=%.cpp.gcov)
GCOV_GCDA_FILES = $(C++_SRC:%.cpp=$(archdir)/%.gcda)
include coverage.mk

C++	= $(CXX)
C++_DEFS = $(OS.C++_DEFS) $(ARCH.C++_DEFS)\
	$(PROJECT.C++_DEFS) $(LOCAL.C++_DEFS) $(TARGET.C++_DEFS) \

C++_FLAGS = $(OS.CXXFLAGS) $(ARCH.CXXFLAGS) \
	$(PROJECT.CXXFLAGS) $(LOCAL.CXXFLAGS) $(TARGET.CXXFLAGS) \
	$(CFLAGS) $(CXXFLAGS)

C++_WARN_FLAGS  = $(OS.C++_WARN_FLAGS) $(ARCH.C++_WARN_FLAGS) \
	$(PROJECT.C++_WARN_FLAGS)

C++_CPPFLAGS = $(CPPFLAGS) \
	$(TARGET.C++_CPPFLAGS) $(LOCAL.C++_CPPFLAGS) $(PROJECT.C++_CPPFLAGS) \
	$(ARCH.C++_CPPFLAGS) $(OS.C++_CPPFLAGS) \
        -I$(includedir)

C++_ALL_FLAGS = $(C++_CPPFLAGS) $(C++_DEFS) $(C++_FLAGS)

C++_LDFLAGS = $(LDFLAGS) \
	$(ARCH.LDFLAGS) $(OS.LDFLAGS) \
	$(PROJECT.LDFLAGS) $(LOCAL.LDFLAGS) $(TARGET.LDFLAGS) \
	-L$(libdir)

C++_LDLIBS = $(LOADLIBES) $(LDLIBS) \
	$(OS.LDLIBS) $(ARCH.LDLIBS) \
	$(PROJECT.LDLIBS) $(LOCAL.LDLIBS) $(TARGET.LDLIBS)

C++_OBJ	= $(C++_SRC:%.cpp=$(archdir)/%.o)
C++_MAIN_OBJ = $(C++_MAIN_SRC:%.cpp=$(archdir)/%.o)
C++_MAIN = $(C++_MAIN_SRC:%.cpp=$(archdir)/%)

#
# main: --Build a program from a file that contains "main".
#
# Remarks:
# This isn't as useful as you might think, because it doesn't include
# any other objects explicitly (although you can reference objects
# indirectly via a (sub) library.
#
$(archdir)/%: $(archdir)/%.o
	$(ECHO_TARGET)
	@echo $(C++) -o $@ $(C++_ALL_FLAGS) $(C++_LDFLAGS) $^ $(C++_LDLIBS)
	@$(C++) -o $@ $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) $(C++_LDFLAGS) $^ $(C++_LDLIBS)

#
# %.o: --Compile a C++ file into an arch-specific sub-directory.
#
$(archdir)/%.o: %.cpp mkdir[$(archdir)]
	$(ECHO_TARGET)
	@echo $(C++) $(C++_ALL_FLAGS) -c -o $(archdir)/$*.o $<
	@$(C++) $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) -c -o $@ \
	    -MMD -MF $(archdir)/$*-depend.mk $<

#
# %.o: --Compile an arch-specific C++ file into an arch-specific sub-directory.
#
$(archdir)/%.o: $(archdir)/%.cpp
	$(ECHO_TARGET)
	@echo $(C++) $(C++_ALL_FLAGS) -c -o $(archdir)/$*.o $<
	@$(C++) $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) -c -o $@ \
	    -MMD -MF $(archdir)/$*-depend.mk $<

#
# build[%]: --Build a C++ file's related object.
#
build[%.cpp]:   $(archdir)/%.o; $(ECHO_TARGET)

#
# %.hpp: --Install a C++ header (.hpp) file.
#
$(includedir)/%.hpp:	%.hpp;		$(INSTALL_FILE) $? $@
$(includedir)/%.hpp:	$(archdir)/%.hpp;	$(INSTALL_FILE) $? $@

#
# build: --Build the C++ files (as defined by C++_SRC, C++_MAIN_SRC)
#
# Remarks:
# Note that C++_MAIN isn't built
#
build:	$(C++_OBJ)

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
clean:	c++-clean
.PHONY:	c++-clean
c++-clean:
	$(ECHO_TARGET)
	$(RM) $(C++_OBJ) $(C++_MAIN)

#
# tidy: --Reformat C++ files consistently.
#
tidy:	c++-tidy
.PHONY:	c++-tidy
c++-tidy:
	$(ECHO_TARGET)
	INDENT_PROFILE=$(DEVKIT_HOME)/etc/.indent.pro indent $(H++_SRC) $(C++_SRC)
#
# toc: --Build the table-of-contents for C++ files.
#
.PHONY: c++-toc
toc:	c++-toc
c++-toc:
	$(ECHO_TARGET)
	mk-toc $(H++_SRC) $(C++_SRC)

#
# src: --Update the C++_SRC, H++_SRC, C++_MAIN_SRC macros.
#
src:	c++-src
.PHONY:	c++-src
c++-src:
	$(ECHO_TARGET)
	@mk-filelist -qn C++_SRC *.cpp
	@mk-filelist -qn C++_MAIN_SRC \
		$$(grep -l '^ *int *main(' *.cpp 2>/dev/null)
	@mk-filelist -qn H++_SRC *.hpp

#
# tags: --Build vi, emacs tags files for C++ files.
#
.PHONY: c++-tags
tags:	c++-tags
c++-tags:
	$(ECHO_TARGET)
	ctags 	$(H++_SRC) $(C++_SRC) && \
	etags	$(H++_SRC) $(C++_SRC); true

#
# todo: --Find "unfinished work" comments in C++ files.
#
.PHONY: c++-todo
todo:	c++-todo
c++-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(H++_SRC) $(C++_SRC) /dev/null || true
