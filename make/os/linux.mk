#
# LINUX.MK	--Macros and definitions for Linux.
#
# Remarks:
# Assembler options used in CFLAGS are (see as(1) for details)
#   -ac omit false conditionals
#   -ad omit debugging directives
#   -ag include general information, like as version and options passed
#   -ah include high-level source
#   -al include assembly
#   -am include macro expansions
#   -an omit forms processing
#   -as include symbols
#   =file set the name of the listing file
#
include os/posix.mk

.LIBPATTERNS = lib%.a lib%.so
LD_SHARED_FLAGS = -shared

OS.CFLAGS 	= -MMD -ffunction-sections -fdata-sections -Wa,-adglmsn=$(@:%.o=%.s)
OS.C_DEFS	= -D__Linux__ -D_DEFAULT_SOURCE -D_XOPEN_SOURCE

OS.C++_DEFS	= -D__Linux__ -D_DEFAULT_SOURCE -D_XOPEN_SOURCE
OS.CXXFLAGS 	= $(OS.CFLAGS)
OS.LDFLAGS	= -Wl,-Map=$@.map -Wl,--gc-sections

OS.PYTEST_FLAGS = --junitxml pytest-tests.xml
OS.C++_LINT_FLAGS = --std=posix
OS.C_LINT_FLAGS = --std=posix

PKG_TYPE	= deb

+vars:   $(.VARIABLES:%=+var[%])
