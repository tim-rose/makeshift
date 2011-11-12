#
# Makefile --Build rules for the vcs directory of devkit.
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
MAKEFLAGS=-I..
MK_SRC = .mk git.mk svn.mk
subdir	= vcs

include devkit.mk 

$(includedir)/%:	%;		$(INSTALL_DATA) $< $@

installdirs:		$(includedir)
install:		$(MK_SRC:%=$(includedir)/%)

.mk:		dot-mk.sh;		sh dot-mk.sh >$@
src:		.mk src-vcs
src-vcs:	;	mk-filelist -qn MK_SRC *.mk .mk

clean:		clean-vcs
clean-vcs:	;		$(RM) .mk .mk.*
