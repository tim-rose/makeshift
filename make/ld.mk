#
# LD.MK --Rules for linking objects into executables.
#
# Contents:
# main: --Build a program from a file that contains "main".
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

ALL_LDFLAGS = $(LDFLAGS) \
    $(LANG.LDFLAGS) \
    $(ARCH.LDFLAGS) $(OS.LDFLAGS) \
    $(PROJECT.LDFLAGS) $(LOCAL.LDFLAGS) $(TARGET.LDFLAGS) \

ALL_LDLIBS = $(TARGET.LDLIBS) $(LOCAL.LDLIBS) $(PROJECT.LDLIBS) \
    $(ARCH.LDLIBS) $(OS.LDLIBS) $(LDLIBS) $(LOADLIBES) \
    -L$(libdir)

#
# main: --Build a program from a file that contains "main".
#
$(archdir)/%: $(archdir)/%.o
	$(ECHO_TARGET)
	$(LD) -Wl,-map,$(archdir)/$*.map $(ALL_LDFLAGS) -o $@ $^ $(ALL_LDLIBS)
