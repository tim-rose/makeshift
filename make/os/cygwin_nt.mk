#
# CYGWIN_NT.MK	--Definitions for Windows using the Cygwin environment.
#
# Remarks:
#
include os/posix.mk

OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__Cygwin_NT__

OS.CXXFLAGS 	= -MMD
OS.C++_DEFS	= -D__Cygwin_NT__

DESTDIR		= /
