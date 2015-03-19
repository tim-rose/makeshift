#
# YACC.MK --Rules for working with YACC objects.
#
# Contents:
# build: --Compile yacc grammars into their object file(s).
# clean: --Remove a yacc grammar's object file.
# src:   --Get a list of the yacc grammars in this directory.
# toc:   --Update the table-of-contents for a yacc grammar file.
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
# build: --Compile yacc grammars into their object file(s).
#
pre-build:	src-var-defined[Y_SRC]
build:	$(Y_OBJ)

#
# clean: --Remove a yacc grammar's object file.
#
clean:	yacc-clean
.PHONY:	yacc-clean
yacc-clean:
	$(ECHO_TARGET)
	$(RM) $(Y_OBJ)

#
# src: --Get a list of the yacc grammars in this directory.
#
src:	yacc-src
.PHONY:	yacc-src
yacc-src:
	$(ECHO_TARGET)
	@mk-filelist -qn Y_SRC *.y

#
# toc: --Update the table-of-contents for a yacc grammar file.
#
toc:	yacc-toc
.PHONY:	yacc-toc
yacc-toc:	
	$(ECHO_TARGET)
	mk-toc $(Y_SRC)
