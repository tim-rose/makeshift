#
# LINUX.MK	--Macros and definitions for Linux.
#
# Remarks:
#
include os/posix.mk

.LIBPATTERNS = lib%.a lib%.so
LD_SHARED_FLAGS = -shared

OS.CFLAGS 	= -MMD -ffunction-sections -fdata-sections
OS.C_DEFS	= -D__Linux__ -D_DEFAULT_SOURCE -D_XOPEN_SOURCE

OS.C++_DEFS	= -D__Linux__ -D_DEFAULT_SOURCE -D_XOPEN_SOURCE
OS.CXXFLAGS 	= -MMD
OS.LDFLAGS	= -Wl,-Map=$@.map -Wl,--gc-sections

OS.PYTEST_FLAGS = --junitxml pytest-tests.xml
OS.C++_LINT_FLAGS = --std=posix
OS.C_LINT_FLAGS = --std=posix

PKG_TYPE	= deb

+vars:   $(.VARIABLES:%=+var[%])
