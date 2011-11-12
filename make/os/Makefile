#
# Makefile --Build rules for the os directory of devkit.
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
MAKEFLAGS=-I..
MK_SRC = .mk darwin.mk linux.mk solaris.mk windows_nt.mk
subdir	= os

include devkit.mk 

$(includedir)/%:	%;		$(INSTALL_DATA) $< $@

installdirs:		$(includedir)
install:		$(MK_SRC:%=$(includedir)/%)

.mk:			dot-mk.sh;		sh dot-mk.sh >$@
src:			.mk src-os
src-os:
	mk-filelist -qn MK_SRC *.mk .mk

clean:	clean-os
clean-os:		;		$(RM) .mk .mk.*
