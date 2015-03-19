#
# C++.MK --Rules for building C++ objects and programs.
#
# Contents:
# cpp_compile_rules: --Dyamically generate rules for C++ files.
# %.o:               --Compile a C++ file into an arch-specific sub-directory.
# %.o:               --Compile an arch-specific C++ file into an arch-specific sub-directory.
# build[%]:          --Build a C++ file's related object.
# %.gcov:            --Build a text-format coverage report.
# cpp_include_rules: --Dyamically generate rules for handling C++ headers.
# build:             --Build the C++ files (as defined by C++_SRC, C++_MAIN_SRC)
# clean:             --Remove objects and executables created from C++ files.
# tidy:              --Reformat C++ files consistently.
# toc:               --Build the table-of-contents for C++ files.
# src:               --Update the C++_SRC, H++_SRC, C++_MAIN_SRC macros.
# tags:              --Build vi, emacs tags files for C++ files.
# todo:              --Find "unfinished work" comments in C++ files.
#
# Remarks:
# The C++ module provides rules and targets for building software
# using the C++ language.
#

#
# Include any dependency information that's available.
#
-include $(C++_SRC:%.cpp=$(archdir)/%.d)

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

#
# Initialise the derived-from-src variables, they are built up incrementally
# by the cpp_compile_rules invocations.
#
C++_OBJ	:=
C++_MAIN_OBJ :=
C++_MAIN :=

#
# Alas, there's no agreed "standard" suffix for C++ files, so
# we generate pattern rules for every reasonable possibility.
# Along with the rules, we incrementally define the macros
# C++_SRC, C++_OBJ, C++_MAIN to cover all the variations.
#
c++-suffix =  cc C cpp cxx c++
h++-suffix = h hpp hxx h++

#
# cpp_compile_rules: --Dyamically generate rules for C++ files.
#
# Parameter:
# $1 --the filename suffix for C++ files.
#
# Remarks:
# This macro creates a set of pattern rules that describe how to compile
# C++ files with the given file suffix.  It also appends to $(C++_SRC)
# and $(C++_OBJ) so that these macros end up with a "complete" list of
# all the C++ source.
#
+var[cpp_compile_rules]:;# disable +var[%]
define cpp_compile_rules

-include $$(C++_$1_SRC:%.$1=$$(archdir)/%.d)

C++_SRC  += $$(C++_$1_SRC)
C++_OBJ  += $$(C++_$1_SRC:%.$1=$$(archdir)/%.o)
C++_MAIN += $(C++_$1_MAIN_SRC:%.$1=$(archdir)/%)

#
# %.o: --Compile a C++ file into an arch-specific sub-directory.
#
$$(archdir)/%.o: %.$1
	$$(ECHO_TARGET)
	@mkdir -p $$(archdir)
	@echo $$(C++) $$(C++_ALL_FLAGS) -c -o $$@ $$<
	@$$(C++) $$(C++_WARN_FLAGS) $$(C++_ALL_FLAGS) -c -o $$@ $$<

#
# %.o: --Compile an arch-specific C++ file into an arch-specific sub-directory.
#
$$(archdir)/%.o: $$(archdir)/%.$1
	$$(ECHO_TARGET)
	@mkdir -p $$(archdir)
	@echo $$(C++) $$(C++_ALL_FLAGS) -c -o $$@ $$<
	@$$(C++) $$(C++_WARN_FLAGS) $$(C++_ALL_FLAGS) -c -o $$@ $$<
#
# build[%]: --Build a C++ file's related object.
#
build[%.$1]:   $$(archdir)/%.o; $$(ECHO_TARGET)


#
# %.gcov: --Build a text-format coverage report.
#
%.$1.gcov:	$$(archdir)/%.gcda
	$$(ECHO_TARGET)
	@mkdir -p $$(archdir)
	@echo gcov -o $$(archdir) $$*.$1
	@gcov -o $$(archdir) $$*.$1 | sed -ne '/^Lines/s/.*:/gcov $$*.$1: /p'
endef
$(foreach suffix,$(c++-suffix),$(eval $(call cpp_compile_rules,$(suffix))))

#
# cpp_include_rules: --Dyamically generate rules for handling C++ headers.
#
+var[cpp_include_rules]:;# disable +var[%]
define cpp_include_rules

H++_SRC += $$(H++_$1_SRC)

#
# %.h++: --Install a C++ header (.hpp) file.
#
$$(includedir)/%.$1:	%.$1;			$$(INSTALL_FILE) $$? $$@
$$(includedir)/%.$1:	$$(archdir)/%.$1;	$$(INSTALL_FILE) $$? $$@
endef
$(foreach suffix,$(h++-suffix),$(eval $(call cpp_include_rules,$(suffix))))

#
# +c++-defines: --Print a list of predefined macros for the "C++" language.
#
# Remarks:
# This target uses gcc-specific compiler options, so it may not work
# on your compiler...
#
+c++-defines:
	@touch ..c;  $(C++) -E -dM ..c; $(RM) ..c

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
	@for suffix in $(c++-suffix); do \
	    mk-filelist -qn C++_$${suffix}_SRC *.$${suffix}; \
	    mk-filelist -qn C++_$${suffix}_MAIN_SRC \
		$$(grep -l '^ *int *main(' *.$${suffix} 2>/dev/null); \
	done
	@for suffix in $(h++-suffix); do \
	    mk-filelist -qn H++_$${suffix}_SRC *.$${suffix}; \
	done

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
