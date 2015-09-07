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

-include $(LEX_SRC:%.l=$(archdir)/%_l.d)

LEX_OBJ	= $(LEX_SRC:%.l=$(archdir)/%.o)

#
# %.l: --Compile the lex grammar into a ".c" file
#
%.c:	%.l
	$(LEX) $(LFLAGS) -t $< | sed -e "s/yy/$*_/g" >$*_l.c

#
# build: --Compile LEX_SRC to object code.
#
pre-build:	src-var-defined[LEX_SRC]
build:	$(LEX_OBJ)

#
# clean: --Remove the lex grammar's object files.
#
clean:	clean-lex
clean-lex:
	$(ECHO_TARGET)
	$(RM) $(LEX_OBJ)

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
