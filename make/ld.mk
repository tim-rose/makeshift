#
# LD.MK --Rules for linking objects into executables.
#
# Contents:
# main:         --Build a program from a file that contains "main".
# subdir/lib.a: --Force sublibs do be re-evaluated
#
# Remarks:
# The "ld" module defines pattern rules for building executables from
# a list of objects and/or libraries.  the $(LD) macro automatically
# defaults to the C or C++ compiler, so you shouldn't need to set it
# in most circumstances.
#
# The behaviour of ld can be customised with $(LDFLAGS).
#
include coverage.mk

#
# The command "ld" is rarely invoked directly, it's more common that it's
# exec'd by a compiler.  When including the lang/*.mk for the language to
# be compiled, the language may override LD with its variation.  If not,
# LD falls back to $(CC).
#
ifeq ($(LD), ld)
    LD = $(CC)
endif

ALL_BUILD_PATH = . $(LIB_ROOT) $(BUILD_PATH)

VPATH = $(ALL_BUILD_PATH:%=%/$(archdir)) $(libdir)

ALL_LDFLAGS = $(LDFLAGS) $(LANG.LDFLAGS) \
    $(TARGET.LDFLAGS) $(LOCAL.LDFLAGS) \
    $(VPATH:%=-L%) -L$(libdir) \
    $(PROJECT.LDFLAGS) $(ARCH.LDFLAGS) $(OS.LDFLAGS) \

ALL_LDLIBS = $(TARGET.LDLIBS) $(LOCAL.LDLIBS) $(PROJECT.LDLIBS) \
    $(ARCH.LDLIBS) $(OS.LDLIBS) $(LDLIBS) $(LOADLIBES)

#
# main: --Build a program from a file that contains "main".
#
$(archdir)/%: $(archdir)/%.o
	$(ECHO_TARGET)
	$(LD) $(ALL_LDFLAGS) -o $@ $^ $(ALL_LDLIBS)

#
# subdir/lib.a: --Force sublibs do be re-evaluated
#
# Remarks:
# This rule is a bit of a hack to do something in *this* directory,
# which will force its timestamp to be re-evaluated if a "main"
# depends on it.  For other sub-directory dependants, an explicit
# rule (similar to this) must be used.
#
%/$(archdir)/lib.$(LIB_SUFFIX): build@%
	$(ECHO_TARGET)
