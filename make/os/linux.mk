#
# LINUX.MK	--Macros and definitions for Linux.
#
# Remarks:
# _XOPEN_SOURCE ensures some definitions and typedefs are visible
# (e.g. pid_t, stat.mode masks, etc.).  Likewise _BSD_SOURCE ensures
# some functions and type variations (strdup, tm.tm_gmtoff, etc.) are
# defined, even though we enforce strict standards
# compliance/warnings.
#
include os/posix.mk

OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__Linux__ -D_XOPEN_SOURCE -D_BSD_SOURCE

OS.C++_DEFS	= -D__Linux__ -D_XOPEN_SOURCE -D_BSD_SOURCE
OS.CXXFLAGS 	= -MMD
OS.LDFLAGS	= -Wl,-Map,$@.map

OS.PYTEST_FLAGS = --junitxml pytest-tests.xml
OS.C++_LINT_FLAGS = --std=posix
OS.C_LINT_FLAGS = --std=posix

PKG_TYPE	= deb

+vars:   $(.VARIABLES:%=+var[%])
