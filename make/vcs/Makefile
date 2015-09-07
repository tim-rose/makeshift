#
# Makefile --Build rules for the vcs directory of devkit.
#
MK_SRC = git.mk svn.mk
ALL_SRC = $(MK_SRC) .mk
subdir	= vcs

include devkit.mk

$(includedir)/.mk:	_mk.sh;		sh _mk.sh >$@

install:		install-mk
install:		$(includedir)/.mk
