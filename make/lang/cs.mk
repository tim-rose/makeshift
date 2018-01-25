#
# CS.MK --Rules for building C# libraries and programs. The rules are written
#         for the Microsoft CSC.EXE compiler. Support for buiding on Linux or BSD with mono
#         has not yet been implemented.
#
# Contents:
# build:   --Build all the c# sources that have changed.
# install: --install c# binaries and libraries.
# clean:   --Remove c# class files.
# src:     --Update the CS_SRC macro.
# todo:    --Report "unfinished work" comments in CSC files.
#
#
.PHONY: $(recursive-targets:%=%-cs)

CS_SUFFIX ?= cs

# TODO: these are essentially specific to the windows platform and should probably go to
#       one of the os/*.mk
LIB_SUFFIX ?= dll
EXE_SUFFIX ?= exe

# this regex searches for the main-function in C#, which normally is:
# static void Main
CS_MAIN_RGX ?= '^[ \t]*static[ \t]*void[ \t]Main'

ifdef autosrc
    LOCAL_CS_SRC := $(shell find . -path ./obj -prune -o -type f -name '*.$(CS_SUFFIX)' -print)
    LOCAL_CS_MAIN := $(shell grep -l $(CS_MAIN_RGX) '*.$(CS_SUFFIX)') 
    CS_SRC ?= $(LOCAL_CS_SRC)
    CS_MAIN_SRC ?= $(LOCAL_CS_MAIN)
endif

# these rules assume that the C# code is organised as follows:
#  - the assembly or program name is the same as the directory name where the Makefile resides
#  - the cs source files are at the same level or in subdirectories; these subdirs have no further
#    Makefile recursion!
#  - if this builds an executable, the main file resides in the same directory as the Makefile and
#    has the 'static void Main' function
# when organised this way, these rules autodetect whether to build a library or executable and
# what name to give it. The name can be overridden in the local Makefile.
MODULE_NAME ?= $(shell basename $$(pwd))

ifdef CS_MAIN_SRC
  # Main file detected, so we are building an executable
    TARGET := $(MODULE_NAME).$(EXE_SUFFIX)
    TARGET.CS_FLAGS += -target:winexe
else
  # no main file, so we assume we're building a library
    TARGET := $(MODULE_NAME).$(LIB_SUFFIX)
    TARGET.CS_FLAGS += -target:library
endif

ifdef KEY_FILE
  TARGET.CS_FLAGS += -keyfile:$(KEY_FILE)
endif

CSC ?= $(CS_BINDIR)csc.exe

ALL_CS_FLAGS = $(VARIANT.CS_FLAGS) $(OS.CS_FLAGS) $(ARCH.CS_FLAGS) $(LOCAL.CS_FLAGS) \
    $(TARGET.CS_FLAGS) $(PROJECT.CS_FLAGS) $(CS_FLAGS)

# All assemblies that are references need to be passed to the compiler; for the moment
# these rules assume references are given by full path! This because of the variety
# of .Net Framework versions that exist and can be used in mixed fashion.
# How to use:
# similar to languages, specify dotnet_frameworks. The names for each framework can be
# freely chosen. For example:
# dotnet_frameworks = v2_0 v3_5 v4_5_1
# then for each of the specified frameworks, you need to specify the directory where the
# frameworks reside as <framework_name>.dir. This can easily be done in the project.mk
# makefile as the locations would be static across the project. For the example above, the
# project make could have:
# v2_0.dir = /c/Windows/Framework/2.0.5057
# v3_5.dir = /c/Program Files (x86)/Reference Assemblies/Microsoft/Framework/v3.5
# and so forth.
# then lastly, at the module level, one would define a variable <framework_name>.ref with
# all references to use from that framework (without the extension). E.g.
# v2_0.ref = mscorlib System System.Data
# in addition, projects can add references to the LOCAL.CS_REFS flag
TARGET.CS_REFS = $(foreach f,$(dotnet_frameworks),$($(f).ref:%=-reference:$($(f).dir)%.$(LIB_SUFFIX)))

ALL_CS_REFS = $(VARIANT.CS_REFS) $(OS.CS_REFS) $(ARCH.CS_REFS) $(LOCAL.CS_REFS) \
    $(TARGET.CS_REFS) $(PROJECT.CS_REFS) $(CS_REFS)

#
# build: --Build all the cs sources that have changed.
#
build:		build-cs
build-cs: $(archdir)/$(TARGET)

$(archdir)/$(TARGET): $(CS_SRC) | $(archdir)
	$(ECHO_TARGET)
	$(CSC) $(ALL_CS_FLAGS) $(ALL_CS_REFS) $^ "-out:$@"

#
# TODO: install: --install cs binaries and libraries.
#
install-cs:	
	$(ECHO_TARGET)

uninstall-cs:
	$(ECHO_TARGET)

#
# clean: --Remove build outputs
#
distclean:	clean-cs
clean:	clean-cs
clean-cs:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(TARGET)

#
# src: --Update the CS_SRC macro.
#      exclude ./obj from the search path, Visual Studio sometimes generates files here.
#      other than that, all .cs files in the directory tree from here are condidered part of
#      this module.
#
src:	src-cs
src-cs:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn CS_SRC $$(find . -path ./obj -prune -o -type f -name '*.$(CS_SUFFIX)' -print)
	@mk-filelist -f $(MAKEFILE) -qn CS_MAIN_SRC $$(grep -l $(CS_MAIN_RGX) ''*.$(CS_SUFFIX)'' 2>/dev/null)

#
# todo: --Report "unfinished work" comments in Java files.
#
todo:	todo-cs
todo-cs:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(CS_SRC) /dev/null || true
