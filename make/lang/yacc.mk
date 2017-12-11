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

ifdef autosrc
    LOCAL_YACC_SRC := $(wildcard *.y)
    YACC_SRC ?= $(LOCAL_YACC_SRC)
endif

ifdef o
YACC_OBJ = $(YACC_SRC:%.y=$(archdir)/%_y.$(o))
endif
ifdef s.o
YACC_PIC_OBJ = $(YACC_SRC:%.y=$(archdir)/%_y.$(s.o))
endif

YACC_H	= $(YACC_SRC:%.y=$(gendir)/%.h)
YACC_C	= $(YACC_SRC:%.y=$(gendir)/%_y.c)

.PRECIOUS:	$(YACC_H) $(YACC_C)

ALL_YFLAGS = $(OS.YFLAGS) $(ARCH.YFLAGS) \
    $(PROJECT.YFLAGS) $(LOCAL.YFLAGS) $(TARGET.YFLAGS) $(YFLAGS)

-include $(YACC_SRC:%.y=$(archdir)/%_y.d)

#
# %.y: --Compile the yacc grammar into ".h" and ".c" files.
#
# Remarks:
# Building the ".c" files from yacc is a little tricky, because the
# (traditional) yacc output is the same (y.tab.c) regardless of the
# input file.  This makes parallel builds problematic, so the source
# is copied into a temporary directory so that the y.tab.c file can be
# created independently and in parallel.
# Note: "modern" yacc (usually, bison) avoids these problems.
#
$(gendir)/%.h $(gendir)/%_y.c:	%.y | $(gendir)
	$(ECHO_TARGET)
	$(MKDIR) $(tmpdir)
	$(CP) $*.y $(tmpdir) && cd $(tmpdir) && $(YACC) -d $(ALL_YFLAGS) $<
	base=$$(echo "$*"| tr a-z A-Z); \
	sed -e "s/yy/$*_/g" -e "s/YY/$${base}_/g" <$(tmpdir)/y.tab.h >$(gendir)/$*.h; \
	sed -e "s/yy/$*_/g" -e "s/YY/$${base}_/g" <$(tmpdir)/y.tab.c >$(gendir)/$*_y.c
	$(RM) -r $(tmpdir)

#
# build: --Compile YACC_SRC to object code.
#
build:	build-yacc
build-yacc: $(YACC_OBJ) $(YACC_PIC_OBJ) $(YACC_H)

#
# clean: --Remove a yacc grammar's object file.
#
clean:	clean-yacc
clean-yacc:
	$(ECHO_TARGET)
	$(RM) $(YACC_H) $(YACC_C) $(YACC_OBJ) $(YACC_PIC_OBJ) $(YACC_SRC:%.y=$(archdir)/%_y.d)

#
# src: --Get a list of the yacc grammars in this directory.
#
src:	src-yacc
src-yacc:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn YACC_SRC *.y

#
# toc: --Update the YACC_SRC macro with a list of yacc grammars.
#
toc:	toc-yacc
toc-yacc:
	$(ECHO_TARGET)
	mk-toc $(YACC_SRC)
