#
# POSIX.MK	--Common command definitions for POSIX systems.
#
# Remarks:
# This file contains macros for the commands that makeshift uses,
# corresponding to their usual values for a POSIX (i.e. Unix-like)
# systems.  Most of the other specific OSes (e.g. linux, darwin,
# freebsd etc.) will use these definitions, others may need to define
# their own, or find a way to emulate these commands.
#

o = o
s.o = s.o
a = a
so = so
s.a = s.a

OS.C_SHARED_FLAGS = -fpic
OS.C++_SHARED_FLAGS = -fpic

CHMOD	= chmod
CP 	= cp
FAKEROOT = fakeroot
GREP	= grep
INDENT	= gnuindent
LN      = ln -f
MV	= mv
MKDIR   = mkdir -p
PS2PDF	= pstopdf
RANLIB	= ranlib
RMDIR	= rm_dir() { rmdir -p "$$@" 2>/dev/null ||:; }; rm_dir
SED     = sed
STRIP	= strip
SYMLINK = ln -sf
ARFLAGS = -rv
#
# INSTALL_*: --Specialised install commands.
#
INSTALL 	  ?= install
INSTALL_DATA      = $(INSTALL) -D -m 644
INSTALL_RDONLY    = $(INSTALL) -D -m 444
INSTALL_DIRECTORY = $(INSTALL) -d
INSTALL_SCRIPT    = $(INSTALL) -D -m 755
INSTALL_PROGRAM   = $(INSTALL) -D -m 755

#
# INSTALL_FILE is obsolete, use INSTALL_DATA.
#
INSTALL_FILE      = $(INSTALL) -D -m 644
