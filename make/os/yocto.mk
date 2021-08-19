#
# YOCTO.MK --Adjustments for building in the Yocto environment.
#
# Remarks:
# Yocto is a cross-compile environment, so we need to take care that the
# make will search the sysroots directory for libraries that are built for the
# target machine.  Note that make will fallback to the "usual" places
# otherwise, attempting to link with native/local libraries.
#
VPATH += $(PKG_CONFIG_SYSROOT_DIR)/usr/lib
OS.CFLAGS 	= -MMD
OS.C_DEFS	= -D__Linux__ -D__yocto__ -D_DEFAULT_SOURCE

OS.C++_DEFS	= -D__Linux__ -D__yocto__ -D_DEFAULT_SOURCE
OS.CXXFLAGS 	= -MMD
OS.LDFLAGS	= -Wl,-Map,$@.map
include os/posix.mk
