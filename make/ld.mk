#
# LD.MK --Rules for linking objects into executables.
#
# Contents:
# main: --Build a program from a file that contains "main".
#
# Remarks:
# The "ld" module defines pattern rules for building executables from
# a list of objects and/or libraries.  the "LD" macro automatically
# defaults to the C or C++ compiler, so you shouldn't need to set it
# in most circumstances.
#
ifeq ($(LD), ld)
    LD = $(CC)
endif

ALL_LDFLAGS = $(LDFLAGS) \
    $(LANG.LDFLAGS) \
    $(ARCH.LDFLAGS) $(OS.LDFLAGS) \
    $(PROJECT.LDFLAGS) $(LOCAL.LDFLAGS) $(TARGET.LDFLAGS) \
    -L$(libdir)

ALL_LDLIBS = $(LOADLIBES) $(LDLIBS) \
    $(OS.LDLIBS) $(ARCH.LDLIBS) \
    $(PROJECT.LDLIBS) $(LOCAL.LDLIBS) $(TARGET.LDLIBS) \

#
# main: --Build a program from a file that contains "main".
#
$(archdir)/%: $(archdir)/%.o
	$(ECHO_TARGET)
	@echo "..." $(LD) $(ALL_LDFLAGS) -o $@ $^ $(ALL_LDLIBS)
	$(LD) $(ALL_LDFLAGS) -o $@ $^ $(ALL_LDLIBS)
