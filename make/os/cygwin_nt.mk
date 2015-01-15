#
# CYGWIN_NT.MK	--Macros and definitions for (Cygwin) Windows_NT
#
# Remarks:
#
OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__Windows_NT__

OS.CXXFLAGS 	= -MMD
OS.C++_DEFS	= -D__Windows_NT__

DESTDIR		= /
RANLIB		= ranlib
FAKEROOT	= fakeroot
GREP		= grep
indent          = indent

PKG_TYPE	= deb
