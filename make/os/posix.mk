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

LIB_SUFFIX = a
OBJ_SUFFIX = o

OS.C_SHARED_FLAGS = -fpic
OS.C++_SHARED_FLAGS = -fpic

CHMOD	= chmod
CP 	= cp
FAKEROOT = fakeroot
GREP	= grep
INDENT	= gnuindent
MV	= mv
MKDIR   = mkdir -p
PS2PDF	= pstopdf
RANLIB	= ranlib
RMDIR	= rmdir
STRIP	= strip

#
# INSTALL_*: --Specialised install commands.
#
INSTALL 	  ?= install
INSTALL_FILE      = $(INSTALL) -D -m 644
INSTALL_DATA      = $(INSTALL) -D -m 644
INSTALL_DIRECTORY = $(INSTALL) -d
INSTALL_SCRIPT    = $(INSTALL) -D -m 755
INSTALL_PROGRAM   = $(INSTALL) -D -m 755
