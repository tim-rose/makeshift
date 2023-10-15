#
# ASSEMBLER.MK --Rules for building assembler.
#
# Contents:
# %.o:         --Compile a assembler file into an arch-specific sub-directory.
# archdir/%.o: --Compile a generated assembler file into the arch sub-directory.
# build[%]:    --Build a assembler file's related object.
# install:     --Do nothing.
# clean:       --Remove objects and executables created from assembler files.
# src:         --Update the AS_SRC macro.
# todo:        --Report "unfinished work" comments in assembler files.
# +version:    --Report details of tools used by C.
#
# Remarks:
# The "lang/assembler" module provides support for the assembler language.
# It requires some of the following variables to be defined:
#
#  * AS_SRC	--C header files
#
# TODO: cleanup cppcheck dump files!
#

.PHONY: $(recursive-targets:%=%-as)

ifdef autosrc
    LOCAL_AS_SRC := $(wildcard *.s)

    AS_SRC ?= $(LOCAL_AS_SRC)
    AS_LIB_SRC ?= $(LOCAL_AS_LIB_SRC)
endif

AS_LIB_OBJ = $(AS_LIB_SRC:%.c=$(archdir)/%.$(o))
AS_OBJ	= $(AS_MAIN_OBJ) $(AS_LIB_OBJ)

AS_DEFS	= $(OS.AS_DEFS) $(ARCH.AS_DEFS)\
    $(PROJECT.AS_DEFS) $(LOCAL.AS_DEFS) $(TARGET.AS_DEFS)

AS_FLAGS = $(OS.ASFLAGS) $(ARCH.ASFLAGS) \
    $(PROJECT.ASFLAGS) $(LOCAL.ASFLAGS) $(TARGET.ASFLAGS) $(ASFLAGS)

AS_CPPFLAGS = $(CPPFLAGS) \
    $(TARGET.AS_CPPFLAGS) $(LOCAL.AS_CPPFLAGS) \
    $(BUILD_PATH:%=-I%/include) $(LIB_ROOT:%=-I%/include) \
    $(PROJECT.AS_CPPFLAGS) $(ARCH.AS_CPPFLAGS) $(OS.AS_CPPFLAGS) \
    -I. -I$(gendir) -I$(includedir)

AS_ALL_FLAGS = $(AS_CPPFLAGS) $(AS_DEFS) $(AS_FLAGS)

#
# %.o: --Compile a assembler file into an arch-specific sub-directory.
#
# Remarks:
# This target also builds dependency information as a side effect
# of the build.  Note that it doesn't declare that it builds the
# dependencies, and the "-include" command allows the files to
# be absent, to avoid premature compilation.
#
$(archdir)/%.$(o): %.c | $(archdir)
	$(ECHO_TARGET)
	$(CROSS_COMPILE)$(AS) $(AS_ALL_FLAGS) -c -o $@ $(abspath $<)
#
# archdir/%.o: --Compile a generated assembler file into the arch sub-directory.
#
$(archdir)/%.$(o): $(gendir)/%.s | $(archdir)
	$(ECHO_TARGET)
	$(CROSS_COMPILE)$(AS) $(AS_ALL_FLAGS) -c -o $@ $(abspath $<)

build:	build-as
build-as:; $(ECHO_TARGET)

#
# build any subdirectories before trying to compile stuff;
# library subdirectories may install include files needed
# for compilation.
#
$(AS_OBJ) 	| build-subdirs

#
# build[%]: --Build a assembler file's related object.
#
build[%.s]:   $(archdir)/%.$(o); $(ECHO_TARGET)

#
# install: --Do nothing.
#
# Remarks:
# The install (and uninstall) target is not invoked by default,
# it must be added as a dependent of the "install" target.
#
install-as:; $(ECHO_TARGET)
install-strip-as:; $(ECHO_TARGET)
uninstall-as:; $(ECHO_TARGET)

#
# clean: --Remove objects and executables created from assembler files.
#
clean:	clean-as
clean-as:
	$(ECHO_TARGET)
	$(RM) $(AS_OBJ) $(AS_OBJ:%.$(o)=%.d)

#
# src: --Update the AS_SRC macro.
#
src:	src-as
src-as:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qn AS_SRC $(WILDCARD).s

#
# todo: --Report "unfinished work" comments in assembler files.
#
todo:	todo-as
todo-as:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN)  $(AS_SRC) /dev/null ||:

#
# +version: --Report details of tools used by assembler.
#
+version: cmd-version[$(CROSS_COMPILE)$(AS)] 
