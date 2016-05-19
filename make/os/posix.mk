#
# POSIX.MK	--Common command definitions for POSIX systems.
#
# Remarks:
# This file contains macros for the commands that devkit uses,
# corresponding to their usual values for a POSIX (i.e. Unix-like)
# systems.  Most of the other specific OSes (e.g. linux, darwin,
# freebsd etc.) will use these definitions, others may need to define
# their own, or find a way to emulate these commands.
#

#
# INSTALL_*: --Specialised install commands.
#
INSTALL 	  ?= install -D
INSTALL_PROGRAM   := $(INSTALL) -m 755
INSTALL_FILE      := $(INSTALL) -m 644
INSTALL_DIRECTORY := $(INSTALL) -d

CHMOD		= chmod
CP		= cp
FAKEROOT	= fakeroot
GREP		= grep
INDENT          = gnuindent
MV		= mv
RANLIB		= ranlib
RMDIR		= rmdir
