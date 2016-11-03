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
INSTALL_FILE      := $(INSTALL) -m 644
INSTALL_DIRECTORY := $(INSTALL) -d
ifneq "$(INSTALL_STRIP)" ""
    INSTALL_PROGRAM = \
        install_program() { $(INSTALL) -m755 $$1 $$2 && $(STRIP) $$2 2>/dev/null; };\
        install_program
else
    INSTALL_PROGRAM = $(INSTALL) -m 755
endif

OS.C_SHARED_FLAGS = -fpic
OS.C++_SHARED_FLAGS = -fpic

CHMOD	= chmod
CP 	= cp
FAKEROOT = fakeroot
GREP	= grep
INDENT	= gnuindent
MV	= mv
PS2PDF	= pstopdf
RANLIB	= ranlib
RMDIR	= rmdir
STRIP	= strip
