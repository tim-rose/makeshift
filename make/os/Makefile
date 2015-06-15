#
# Makefile --Build rules for the os directory of devkit.
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
MK_SRC = cygwin_nt.mk darwin.mk linux.mk rtx.mk solaris.mk \
    windows_nt.mk windriver-x.mk
subdir	= os

include devkit.mk

install:		$(MK_SRC:%=$(includedir)/%)
