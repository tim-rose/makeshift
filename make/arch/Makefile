#
# Makefile --Build rules for the arch directory of devkit.
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
MAKEFLAGS=-I..
MK_SRC = .mk all.mk arm.mk avr.mk i386.mk i386_64.mk i686.mk \
    i686_64.mk x86_64.mk
subdir	= arch

include devkit.mk 

$(includedir)/%:	%;		$(INSTALL_DATA) $< $@

installdirs:		$(includedir)
install:		$(MK_SRC:%=$(includedir)/%)

.mk:			dot-mk.sh;		sh dot-mk.sh >$@
src:			.mk src-arch
src-arch:
	mk-filelist -qn MK_SRC *.mk .mk

clean:	clean-arch
clean-arch:		;		$(RM) .mk .mk.*
