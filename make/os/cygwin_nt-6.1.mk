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
indent          = indent

PKG_TYPE	= deb

SH_PATH		= /bin/sh
AWK_PATH	= /usr/bin/awk
SED_PATH	= /usr/bin/sed
PERL_PATH	= /usr/bin/perl
PYTHON_PATH	= /usr/bin/python
