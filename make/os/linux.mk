#
# LINUX.MK	--Macros and definitions for (Debian) Linux.
#
# Remarks:
# The "linux" module provices customisations for the Linux OS.
# The default Linux variant is (currently!?) Debian, and so this
# include file sets up some definitions to assist building Debian
# packages.
#
include os/posix.mk

OS.CFLAGS 	= -MMD
#OS.C_DEFS	= -D__Linux__ -D_XOPEN_SOURCE
OS.C_DEFS	= -D__Linux__

OS.C++_DEFS	= -D__Linux__ -D_XOPEN_SOURCE
OS.CXXFLAGS 	= -MMD
OS.LDFLAGS	= -Wl,-Map,$(archdir)/$*.map

OS.PYTEST_FLAGS = --junitxml pytest-tests.xml
OS.C++_LINT_FLAGS = --std=posix
OS.C_LINT_FLAGS = --std=posix

PKG_TYPE	= deb

+vars:   $(.VARIABLES:%=+var[%])
