#
# ARM --Definitions for ARM.
#
ADDR2LINE ?= addr2line
AR	?= ar
AS = $(CC) -x assembler-with-cpp
C++	?= c++
C++FILT	?= c++filt
CPP	?= cpp
ELFEDIT	?= elfedit
G++	?= g++
GCC	?= gcc
GCC-AR	?= gcc-ar
GCC-NM	?= gcc-nm
GCC-RANLIB ?= gcc-ranlib
# gcov
# gcov-tool
# gdb
# gfortran
# gprof
#LD	?= ld
# ld.bfd
NM	?= nm
# objcopy
# objdump
RANLIB	?= ranlib
# readelf
# size
# strings
# strip
ARCH.ASFLAGS = $(ARCH.CFLAGS)
