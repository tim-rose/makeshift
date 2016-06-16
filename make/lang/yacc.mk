#
# YACC.MK --Rules for working with YACC objects.
#
# Contents:
# %.y:   --Compile the yacc grammar into ".h" and ".c" files.
# build: --Compile LEX_SRC to object code.
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

YACC_OBJ	= $(YACC_SRC:%.y=$(archdir)/%_y.o)
YACC_H_GEN	= $(YACC_SRC:%.y=$(archdir)/%.h)
YACC_C_GEN	= $(YACC_SRC:%.y=$(archdir)/%_y.c)

.PRECIOUS:	$(YACC_H_GEN) $(YACC_C_GEN)

ALL_YFLAGS = $(OS.YFLAGS) $(ARCH.YFLAGS) \
    $(PROJECT.YFLAGS) $(LOCAL.YFLAGS) $(TARGET.YFLAGS) $(YFLAGS)

-include $(YACC_SRC:%.y=$(archdir)/%_y.d)

#
# %.y: --Compile the yacc grammar into ".h" and ".c" files.
#
# TODO: build these files into the arch-subdir.
#
$(archdir)/%.h $(archdir)/%_y.c:	%.y
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	$(YACC) -d $(ALL_YFLAGS) $<
	BASE=$$(echo "$*"| tr a-z A-Z); \
	sed -e "s/yy/$*_/g" -e "s/YY/$${BASE}_/g" <y.tab.h >$(archdir)/$*.h; \
	sed -e "s/yy/$*_/g" -e "s/YY/$${BASE}_/g" <y.tab.c >$(archdir)/$*_y.c
	$(RM) y.tab.[ch]

#
# build: --Compile LEX_SRC to object code.
#
build:	build-yacc
build-yacc: $(YACC_OBJ) $(YACC_H)

#
# clean: --Remove a yacc grammar's object file.
#
clean:	clean-yacc
clean-yacc:
	$(ECHO_TARGET)
	$(RM) $(YACC_OBJ) $(YACC_H) $(YACC_SRC:%.y=$(archdir)/%_y.d)

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
