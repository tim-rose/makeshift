#
# YACC.MK --Rules for working with YACC objects.
#
# Contents:
# %.y:   --Compile the yacc grammar into ".h" and ".c" files.
# build: --Compile YACC_SRC to object code.
# clean: --Remove a yacc grammar's object file.
# src:   --Get a list of the yacc grammars in this directory.
# toc:   --Update the YACC_SRC macro with a list of yacc grammars.
#
# Remarks:
# YACC files are compiled into "C" files which are then handled
# by the rules/definitions for building C programs.  This file
# contains patterns to define the YACC compilation only, the
# C processing definitions are defined, and must be included,
# separately.
#
.PHONY: $(recursive-targets:%=%-yacc)

ifdef AUTOSRC
    LOCAL_YACC_SRC := $(wildcard *.c)
    YACC_SRC ?= $(LOCAL_YACC_SRC)
endif

YACC_OBJ = $(YACC_SRC:%.y=$(archdir)/%_y.o)
YACC_H	= $(YACC_SRC:%.y=$(gendir)/%.h)
YACC_C	= $(YACC_SRC:%.y=$(gendir)/%_y.c)

.PRECIOUS:	$(YACC_H) $(YACC_C)

ALL_YFLAGS = $(OS.YFLAGS) $(ARCH.YFLAGS) \
    $(PROJECT.YFLAGS) $(LOCAL.YFLAGS) $(TARGET.YFLAGS) $(YFLAGS)

-include $(YACC_SRC:%.y=$(archdir)/%_y.d)

#
# %.y: --Compile the yacc grammar into ".h" and ".c" files.
#
# TODO: build these files into the arch-subdir.
#
$(gendir)/%.h $(gendir)/%_y.c:	%.y
	$(ECHO_TARGET)
	$(MKDIR) $(@D)
	$(YACC) -d $(ALL_YFLAGS) $<
	BASE=$$(echo "$*"| tr a-z A-Z); \
	sed -e "s/yy/$*_/g" -e "s/YY/$${BASE}_/g" <y.tab.h >$(gendir)/$*.h; \
	sed -e "s/yy/$*_/g" -e "s/YY/$${BASE}_/g" <y.tab.c >$(gendir)/$*_y.c
	$(RM) y.tab.[ch]

#
# build: --Compile YACC_SRC to object code.
#
build:	build-yacc
build-yacc: $(YACC_OBJ) $(YACC_H)

#
# clean: --Remove a yacc grammar's object file.
#
clean:	clean-yacc
clean-yacc:
	$(ECHO_TARGET)
	$(RM) $(YACC_H) $(YACC_C) $(YACC_OBJ) $(YACC_SRC:%.y=$(archdir)/%_y.d)

#
# src: --Get a list of the yacc grammars in this directory.
#
src:	src-yacc
src-yacc:
	$(ECHO_TARGET)
	@mk-filelist -qn YACC_SRC *.y

#
# toc: --Update the YACC_SRC macro with a list of yacc grammars.
#
toc:	toc-yacc
toc-yacc:
	$(ECHO_TARGET)
	mk-toc $(YACC_SRC)
