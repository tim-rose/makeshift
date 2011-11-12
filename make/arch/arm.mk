#
# ARM --Definitions for ARM.
#
# Remarks:
# The ARM setup is a "cross" compile setup, so we need to redefine the
# compiler toolchain.
#
arm_id	= arm-iwmmxt-linux-gnueabi
C_ARCH_DEFS =
CC	= /usr/bin/$(arm_id)-gcc
AR	= /usr/bin/$(arm_id)-ar
LD	= /usr/bin/$(arm_id)-ld
RANLIB	= /usr/bin/$(arm_id)-ranlib
