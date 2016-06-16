#
# LEX.MK --Rules for working with LEX files.
#
# Contents:
# %.l:   --Compile the lex grammar into a ".c" file
# build: --Compile LEX_SRC to object code.
# clean: --Remove the lex grammar's object files.
# src:   --Update the LEX_SRC macro.
# toc:   --Update the table of contents in lex files.
#
# Remarks:
# LEX files are pre-processed into "C" files which are then handled
# by the rules/definitions for building C programs.  This file
# contains patterns to define the pre-processing transformation only.
#
.PHONY: $(recursive-targets:%=%-lex)

ifdef AUTOSRC
    DEFAULT_LEX_SRC := $(wildcard *.c)
    LEX_SRC ?= $(DEFAULT_LEX_SRC)
endif
LEX_OBJ	= $(LEX_SRC:%.l=$(archdir)/%_l.o)
LEX_GEN	= $(LEX_SRC:%.l=$(archdir)/%_l.c)

.PRECIOUS:	$(LEX_GEN)

-include $(LEX_SRC:%.l=$(archdir)/%_l.d)

ALL_LFLAGS = $(OS.LFLAGS) $(ARCH.LFLAGS) \
    $(PROJECT.LFLAGS) $(LOCAL.LFLAGS) $(TARGET.LFLAGS) $(LFLAGS)

#
# %.l: --Compile the lex grammar into a ".c" file
#

$(archdir)/%_l.c:	%.l | mkdir[$(archdir)]
	$(ECHO_TARGET)
	BASE=$$(echo "$*"| tr a-z A-Z); \
            $(LEX) $(ALL_LFLAGS) -t $< | \
            sed -e "s/yy/$*_/g" -e "s/YY/$${BASE}_/g" >$(archdir)/$*_l.c

#
# build: --Compile LEX_SRC to object code.
#
build:	$(LEX_OBJ)

#
# clean: --Remove the lex grammar's object files.
#
clean:	clean-lex
clean-lex:
	$(ECHO_TARGET)
	$(RM) $(LEX_OBJ) $(LEX_SRC:%.l=$(archdir)/%_l.d)

#
# src: --Update the LEX_SRC macro.
#
src:	src-lex
src-lex:
	$(ECHO_TARGET)
	@mk-filelist -qn LEX_SRC *.l

#
# toc: --Update the table of contents in lex files.
#
toc:	toc-lex
toc-lex:
	$(ECHO_TARGET)
	mk-toc $(LEX_SRC)
