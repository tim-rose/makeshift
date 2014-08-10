#
# ARM --Definitions for ARM.
#
# Remarks:
# The "arch/arm" module is a "cross" compile setup, that redefines the
# compiler toolchain.
#
arm_id	= arm-iwmmxt-linux-gnueabi
CC	= /usr/bin/$(arm_id)-gcc
AR	= /usr/bin/$(arm_id)-ar
LD	= /usr/bin/$(arm_id)-ld
RANLIB	= /usr/bin/$(arm_id)-ranlib
