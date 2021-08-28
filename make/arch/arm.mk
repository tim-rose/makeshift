#
# ARM --Definitions for ARM.
#
# Remarks:
# The "arch/arm" module is a (currently!) "cross" compile setup, that redefines the
# compiler toolchain.
# REVIST: compiler toolchains!?
#
#CROSS	?= arm-iwmmxt-linux-gnueabi
#CROSS	?= arm-linux-gnueabihf

CC	?= $(CROSS:%=%-)gcc

ADDR2LINE ?= $(CROSS:%=%-)addr2line
AR	?= $(CROSS:%=%-)ar
AS	?= $(CROSS:%=%-)as
C++	?= $(CROSS:%=%-)c++
C++FILT	?= $(CROSS:%=%-)c++filt
CPP	?= $(CROSS:%=%-)cpp
ELFEDIT	?= $(CROSS:%=%-)elfedit
G++	?= $(CROSS:%=%-)g++
GCC	?= $(CROSS:%=%-)gcc
GCC-AR	?= $(CROSS:%=%-)gcc-ar
GCC-NM	?= $(CROSS:%=%-)gcc-nm
GCC-RANLIB ?= $(CROSS:%=%-)gcc-ranlib
# $(CROSS:%=%-)gcov
# $(CROSS:%=%-)gcov-tool
# $(CROSS:%=%-)gdb
# $(CROSS:%=%-)gfortran
# $(CROSS:%=%-)gprof
#LD	?= $(CROSS:%=%-)ld
# $(CROSS:%=%-)ld.bfd
NM	?= $(CROSS:%=%-)nm
# $(CROSS:%=%-)objcopy
# $(CROSS:%=%-)objdump
RANLIB	?= $(CROSS:%=%-)ranlib
# $(CROSS:%=%-)readelf
# $(CROSS:%=%-)size
# $(CROSS:%=%-)strings
# $(CROSS:%=%-)strip
