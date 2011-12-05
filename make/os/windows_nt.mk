#
# WINDOWS_NT.MK	--Macros and definitions for (Cygwin) Windows_NT
#
# Remarks:
#
C_OS_DEFS	= -D__Windows_NT__
# -D_BSD_SOURCE -D_XOPEN_SOURCE
CXX_OS_DEFS	= -D__Windows_NT__
# -D_BSD_SOURCE -D_XOPEN_SOURCE

RANLIB		= ranlib
FAKEROOT	= fakeroot
GREP		= grep

PKG_TYPE	= deb

PERL_PATH	= /usr/bin/perl
PYTHON_PATH	= /usr/bin/python
SH_PATH		= /bin/sh
