#
# NOSYS.MK	--Macros and definitions for "no system"..
#
# Remarks:
# NOSYS is useful for embedded environments, where the image is completely
# self contained (i.e. includes its own scheduler etc.). E.g. freeRTOS, RTX,
# etc.
#
include os/posix.mk

.LIBPATTERNS = lib%.a lib%.so
LD_SHARED_FLAGS = -shared

OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__NOSYS__ -D_DEFAULT_SOURCE
OS.LDLIBS      = -lnosys

OS.C++_DEFS	= -D__NOSYS__ -D_DEFAULT_SOURCE
OS.CXXFLAGS 	= -MMD
OS.LDFLAGS	= -Wl,-Map=$@.map

PKG_TYPE	= deb

+vars:   $(.VARIABLES:%=+var[%])
