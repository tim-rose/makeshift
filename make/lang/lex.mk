#
# LEX.MK --Rules for working with LEX objects.
#
# Contents:
# build() --lex-specific customisations for the "build" target.
# clean() --lex-specific customisations for the "clean" target.
# src()   --lex-specific customisations for the "src" target.
# toc()   --lex-specific customisations for the "toc" target.
# build:  --lex-specific customisations for the "build" target.
# clean:  --lex-specific customisations for the "clean" target.
# src:    --lex-specific customisations for the "src" target.
# toc:    --lex-specific customisations for the "toc" target.
# %.l()   --lex-related build rules.
# build() --lex-specific customisations for the "build" target.
# clean() --lex-specific customisations for the "clean" target.
# src()   --lex-specific customisations for the "src" target.
# toc()   --lex-specific customisations for the "toc" target.
#
# Remarks:
# LEX files are pre-processed into "C" files which are then handled
# by the rules/definitions for building C programs.  This file
# contains patterns to define the pre-processing transformation only.
#

-include $(L_SRC:%.l=$(archdir)/%.mk)

#
# %.l: --lex-related build rules.
#
L_OBJ	= $(L_SRC:%.l=$(archdir)/%.o)
%.c:	%.l
	$(LEX) $(LFLAGS) -t $< | sed -e "s/yy/$*_/g" >$*_l.c

#
# build: --lex-specific customisations for the "build" target.
#
pre-build:	src-var-defined[L_SRC]
build:	$(L_OBJ)

#
# clean: --lex-specific customisations for the "clean" target.
#
clean:	lex-clean
.PHONY:	lex-clean
lex-clean:
	@$(ECHO) "++ make[$@]@$$PWD"
	$(RM) $(L_OBJ)

#
# src: --lex-specific customisations for the "src" target.
#
src:	lex-src
.PHONY:	lex-src
lex-src:	;	@$(ECHO) "++ make[$@]@$$PWD"
	@mk-filelist -qn L_SRC *.l

#
# toc: --lex-specific customisations for the "toc" target.
#
toc:	lex-toc
.PHONY:	lex-toc
lex-toc:	
	@$(ECHO) "++ make[$@]@$$PWD"
	mk-toc $(L_SRC)
