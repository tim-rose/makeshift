#
# LEX.MK --Rules for working with LEX files.
#
# Contents:
# %.l:   --lex-related build rules.
# build: --Compile LEX_SRC to object code.
# clean: --Remove lex-derived objects.
# src:   --Update the LEX_SRC macro.
# toc:   --Update the table of contents in lex files.
#
# Remarks:
# LEX files are pre-processed into "C" files which are then handled
# by the rules/definitions for building C programs.  This file
# contains patterns to define the pre-processing transformation only.
#

-include $(LEX_SRC:%.l=$(archdir)/%_l-depend.mk)

#
# %.l: --lex-related build rules.
#
LEX_OBJ	= $(LEX_SRC:%.l=$(archdir)/%.o)
%.c:	%.l
	$(LEX) $(LFLAGS) -t $< | sed -e "s/yy/$*_/g" >$*_l.c

#
# build: --Compile LEX_SRC to object code.
#
pre-build:	src-var-defined[LEX_SRC]
build:	$(LEX_OBJ)

#
# clean: --Remove lex-derived objects.
#
clean:	lex-clean
.PHONY:	lex-clean
lex-clean:
	$(ECHO_TARGET)
	$(RM) $(LEX_OBJ)

#
# src: --Update the LEX_SRC macro.
#
src:	lex-src
.PHONY:	lex-src
lex-src:
	$(ECHO_TARGET)
	@mk-filelist -qn LEX_SRC *.l

#
# toc: --Update the table of contents in lex files.
#
toc:	lex-toc
.PHONY:	lex-toc
lex-toc:
	$(ECHO_TARGET)
	mk-toc $(LEX_SRC)
