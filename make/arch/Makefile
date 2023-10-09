#
# Makefile --Build rules for the arch directory of makeshift.
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
MK_SRC = all.mk amd64.mk arm-none-eabi.mk arm.mk avr.mk mingw_64.mk \
    stm32.mk x86.mk x86_64.mk
subdir	= arch

include makeshift.mk

install:	install-mk
uninstall:	uninstall-mk
