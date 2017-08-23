#
# WINDOWS_NT.MK	--Definitions for building on Windows.
#
include os/posix.mk

OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__Windows_NT__

OS.CXXFLAGS 	= -MMD
OS.C++_DEFS	= -D__Windows_NT__

DESTDIR		= /
