#
# RTX.MK --Settings for Keil/RTX
#
LIB_PREFIX =
LIB_SUFFIX = lib

OS.C++_DEFS = -DOS_RTX -D__RTX

OS.C_DEFS = -DOS_RTX -D__RTX

CC = armcc
CXX = armcc
AR = armar
LD = armlink

CHMOD		= chmod
CP		= cp
GREP		= grep
INDENT          = gnuindent
MV		= mv
RANLIB = : $(AR) -s
