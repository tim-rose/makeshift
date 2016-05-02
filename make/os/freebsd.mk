#
# FREEBSD.MK	--Macros and definitions for FreeBSD.
#
# Remarks:
# The "freebsd" module provices customisations for the FreeBSD OS.
#
OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__FREEBSD__ -D_BSD_SOURCE -D_XOPEN_SOURCE

OS.C++_DEFS	= -D__FREEBSD__ -D_BSD_SOURCE -D_XOPEN_SOURCE
OS.CXXFLAGS 	= -MMD
OS.LDFLAGS	= -Wl,-Map,$(archdir)/$*.map

OS.PYTEST_FLAGS = --junitxml pytest-tests.xml
OS.C++_LINT_FLAGS = --std=posix
OS.C_LINT_FLAGS = --std=posix

INSTALL		= ginstall -CD
CHMOD		= chmod
CP		= cp
FAKEROOT	= fakeroot
GREP		= grep
INDENT          = gnuindent
MV		= mv
RANLIB		= ranlib
RMDIR		= rmdir

MOC 		= moc-qt4

+vars:   $(.VARIABLES:%=+var[%])
