#
# CYGWIN_NT.MK	--Definitions for Windows using the Cygwin environment.
#
# Remarks:
# For builds on windows, OS is pre-set to "Windows_NT".  However,
# uname(1) outputs "CYGWIN_NT" for the system name, this file allows
# it to be used as an alternative.
#
include os/posix.mk

OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__CYGWIN_NT__ -D _DEFAULT_SOURCE -D _XOPEN_SOURCE

OS.CXXFLAGS 	= -MMD
OS.C++_DEFS	= $(OS.C_DEFS)
