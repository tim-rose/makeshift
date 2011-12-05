#
# LINUX.MK	--Macros and definitions for (Debian) Linux.
#
# Remarks:
# The default Linux variant is (currently!?) Debian, and so this
# include file sets up some definitions to assist building Debian
# packages.
#
C_OS_DEFS	= -D__Linux__ -D_BSD_SOURCE -D_XOPEN_SOURCE
CXX_OS_DEFS	= -D__Linux__ -D_BSD_SOURCE -D_XOPEN_SOURCE

RANLIB		= ranlib
FAKEROOT	= fakeroot
GREP		= grep

PKG_TYPE	= deb

PERL_PATH	= /usr/bin/perl
PYTHON_PATH	= /usr/bin/python
SH_PATH		= /bin/sh

