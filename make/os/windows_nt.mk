#
# WINDOWS_NT.MK	--Macros and definitions for (Cygwin) Windows_NT
#
# Remarks:
#
OS.C_DEFS	= -D__Windows_NT__
# -D_BSD_SOURCE -D_XOPEN_SOURCE
OS.C++_DEFS	= -D__Windows_NT__
# -D_BSD_SOURCE -D_XOPEN_SOURCE

CHMOD		= chmod
CP		= cp
GREP		= grep
INDENT          = indent
MV		= mv
RANLIB		= ranlib
RMDIR		= rmdir

PKG_TYPE	= deb
