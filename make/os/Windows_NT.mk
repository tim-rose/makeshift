#
# WINDOWS_NT.MK	--Definitions for building on Windows.
#
include os/posix.mk

OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__Windows_NT__ -D _DEFAULT_SOURCE -D _XOPEN_SOURCE

OS.CXXFLAGS 	= -MMD
OS.C++_DEFS	= $(OS.C_DEFS)
