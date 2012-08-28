#
# Makefile --Build rules for the vcs directory of devkit.
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
MAKEFLAGS=-I..
MK_SRC = git.mk svn.mk
ALL_SRC = $(MK_SRC) .mk
subdir	= vcs

include devkit.mk 

$(includedir)/%:	%;		$(INSTALL_FILE) $< $@
$(includedir)/.mk:	_mk.sh;		sh _mk.sh >$@

installdirs:		$(includedir)
install:		$(ALL_SRC:%=$(includedir)/%)

src:
	mk-filelist -qn MK_SRC *.mk .mk
