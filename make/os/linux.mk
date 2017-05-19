#
# LINUX.MK	--Macros and definitions for (Debian) Linux.
#
# Remarks:
# The "linux" module provices customisations for the Linux OS.
# The default Linux variant is (currently!?) Debian, and so this
# include file sets up some definitions to assist building Debian
# packages.
#
# _XOPEN_SOURCE ensures some definitions and typedefs are visible
# (e.g. pid_t, stat.mode masks, etc.).  Likewise _BSD_SOURCE ensures
# some functions and type variations (strdup, tm.tm_gmtoff, etc.) are
# defined.
#
include os/posix.mk

OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__Linux__ -D_XOPEN_SOURCE -DBSD_SOURCE

OS.C++_DEFS	= -D__Linux__ -D_XOPEN_SOURCE -DBSD_SOURCE
OS.CXXFLAGS 	= -MMD
OS.LDFLAGS	= -Wl,-Map,$@.map

OS.PYTEST_FLAGS = --junitxml pytest-tests.xml
OS.C++_LINT_FLAGS = --std=posix
OS.C_LINT_FLAGS = --std=posix

PKG_TYPE	= deb

+vars:   $(.VARIABLES:%=+var[%])
