#
# YACC.MK --Rules for working with YACC objects.
#
# Contents:
# %.y:   --Compile the yacc grammar into ".h" and ".c" files.
# build: --Compile the yacc grammar.
# clean: --Remove a yacc grammar's object file.
# src:   --Get a list of the yacc grammars in this directory.
# toc:   --Update the Y_SRC macro with a list of yacc grammars.
#
# Remarks:
# YACC files are compiled into "C" files which are then handled
# by the rules/definitions for building C programs.  This file
# contains patterns to define the YACC compilation only, the
# C processing definitions are defined, and must be included,
# separately.
#

-include $(Y_SRC:%.y=$(archdir)/%.d)

#
# %.y: --Compile the yacc grammar into ".h" and ".c" files.
#
# TODO: build these files into the arch-subdir.
#
Y_OBJ	= $(Y_SRC:%.y=$(archdir)/%.o)
%.h %.c:	%.y
	$(YACC) -d $(YFLAGS) $<
	sed -e "s/yy/$*_/g" <y.tab.h >$*.h
	sed -e "s/yy/$*_/g" <y.tab.c >$*.c
	$(RM) y.tab.[ch]

#
# build: --Compile the yacc grammar.
#
pre-build:	src-var-defined[Y_SRC]
build:	$(Y_OBJ)

#
# clean: --Remove a yacc grammar's object file.
#
clean:	clean-yacc
.PHONY:	clean-yacc
clean-yacc:
	$(ECHO_TARGET)
	$(RM) $(Y_OBJ)

#
# src: --Get a list of the yacc grammars in this directory.
#
src:	src-yacc
.PHONY:	src-yacc
src-yacc:
	$(ECHO_TARGET)
	@mk-filelist -qn Y_SRC *.y

#
# toc: --Update the Y_SRC macro with a list of yacc grammars.
#
toc:	toc-yacc
.PHONY:	toc-yacc
toc-yacc:
	$(ECHO_TARGET)
	mk-toc $(Y_SRC)
