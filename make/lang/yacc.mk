#
# YACC.MK --Rules for working with YACC objects.
#
# Contents:
# build: --yacc-specific customisations for the "build" target.
# clean: --yacc-specific customisations for the "clean" target.
# src:   --yacc-specific customisations for the "src" target.
# toc:   --yacc-specific customisations for the "toc" target.
#
# Remarks:
# YACC files are pre-processed into "C" files which are then handled
# by the rules/definitions for building C programs.  This file
# contains patterns to define the pre-processing transformation only.
#

-include $(Y_SRC:%.y=$(archdir)/%.mk)

#
# %.y:	--yacc-related build rules.
#
Y_OBJ	= $(Y_SRC:%.y=$(archdir)/%.o)
%.h:	%.y
	$(YACC) -d $(YFLAGS) $<
	sed -e "s/yy/$*_/g" <y.tab.h >$*.h
	$(RM) y.tab.h

%.c:	%.y
	$(YACC) $(YFLAGS) $<
	sed -e "s/yy/$*_/g" <y.tab.c >$*_y.c
	$(RM) y.tab.c

#
# build: --yacc-specific customisations for the "build" target.
#
pre-build:	src-var-defined[Y_SRC]
build:	$(Y_OBJ)

#
# clean: --yacc-specific customisations for the "clean" target.
#
clean:	yacc-clean
.PHONY:	yacc-clean
yacc-clean:
	$(ECHO_TARGET)
	$(RM) $(Y_OBJ)

#
# src: --yacc-specific customisations for the "src" target.
#
src:	yacc-src
.PHONY:	yacc-src
yacc-src:
	$(ECHO_TARGET)
	@mk-filelist -qn Y_SRC *.y

#
# toc: --yacc-specific customisations for the "toc" target.
#
toc:	yacc-toc
.PHONY:	yacc-toc
yacc-toc:	
	$(ECHO_TARGET)
	mk-toc $(Y_SRC)
