#
# Makefile --Build rules for the os directory of devkit.
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
MAKEFLAGS=-I..
MK_SRC = darwin.mk linux.mk solaris.mk windows_nt.mk
ALL_SRC = $(MK_SRC) .mk
subdir	= os

include devkit.mk 

$(includedir)/%:	%;		$(INSTALL_DATA) $< $@
$(includedir)/.mk:	_mk.sh;		sh _mk.sh >$@

installdirs:		$(includedir)
install:		$(ALL_SRC:%=$(includedir)/%)

src:
	mk-filelist -qn MK_SRC *.mk 
