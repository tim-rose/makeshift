#
# RTX.MK	--Macros and definitions for Keil/RTX.
#
# Remarks:
# This is a cross-compile setup to compile Keil/RTX stuff on an otherwise
# standard cygwin box.
#
OS.CXXFLAGS = --md

CC = armcc
CXX = armcc
AS = armunk
LD = armlink
GDB = gdb
STRIP = : strip
RANLIB = : ranlib
OBJCOPY = objcopy
OBJDUMP = objdump
AR = armar
NM = : nm

INDENT          = gnuindent
