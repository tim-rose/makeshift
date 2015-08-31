#
# CYGWIN_NT.MK	--Definitions for Windows using the Cygwin environment.
#
# Remarks:
#
OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__Cygwin_NT__

OS.CXXFLAGS 	= -MMD
OS.C++_DEFS	= -D__Cygwin_NT__

DESTDIR		= /

CHMOD		= chmod
CP		= cp
FAKEROOT	= fakeroot
GREP		= grep
INDENT          = indent
MV		= mv
RANLIB		= ranlib

PKG_TYPE	= deb
