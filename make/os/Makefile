#
# Makefile --Build rules for the os directory of devkit.
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
MK_SRC = cygwin_nt.mk darwin.mk linux.mk rtx.mk solaris.mk \
    windows_nt.mk windriver-x.mk
ALL_SRC = $(MK_SRC) .mk
subdir	= os

include devkit.mk

$(includedir)/%:	%;		$(INSTALL_FILE) $* $@
$(includedir)/.mk:	_mk.sh;		sh _mk.sh >$@

install:		$(ALL_SRC:%=$(includedir)/%)
