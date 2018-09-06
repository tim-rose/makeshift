#
# WINDOWS_NT.MK	--Definitions for building on Windows.
#
# Remarks:
# For windows, there are two varieties of builds; a "native" build
# that identifies the OS as Windows_NT (this file), and uses Microsoft's
# tools and frameworks as much as possible, and a "posix" build that
# uses the GNU toolset.
#
# See Also: cygwin_nt.mk
#
include os/posix.mk

OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__Windows_NT__ -D _DEFAULT_SOURCE -D _XOPEN_SOURCE

OS.CXXFLAGS 	= -MMD
OS.C++_DEFS	= $(OS.C_DEFS)
