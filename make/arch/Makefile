#
# Makefile --Build rules for the arch directory of devkit.
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
MK_SRC = all.mk arm.mk avr.mk stm32.mk x86_64.mk
subdir	= arch

include devkit.mk

install:		$(MK_SRC:%=$(includedir)/%)
