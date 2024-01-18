#
# DARWIN.MK	--Macros and definitions for macintosh OS X.
#
# Remarks:
# The "darwin" module contains customisations for the Darwin OS,
# i.e. Mac OS X.  Libraries are a little quirky under darwin, and in
# particular, you can't move a library after building it.  ranlib(1)
# resets whatever needs to be done, and the build rules will apply it
# if defined.
#
include os/posix.mk

CC ?= cc
.LIBPATTERNS = lib%.dylib lib%.a

so = dylib
LD_SHARED_FLAGS = -Wl,-undefined,dynamic_lookup -Wl,-install_name,$(notdir $@) -dynamiclib

OS.CFLAGS 	= -MMD
OS.C_WARN_FLAGS = -Wno-gnu-zero-variadic-macro-arguments
OS.C_CPPFLAGS   = -I/usr/local/include -I/opt/local/include
OS.C_DEFS       = -D__Darwin__

OS.C++_CPPFLAGS = -I/usr/local/include -I/opt/local/include
OS.C++_DEFS     = -D__Darwin__
OS.CXXFLAGS 	= -MMD

OS.LDFLAGS	= -Wl,-map,$(archdir)/$*.map
# REVISIT: need a cleaner way to add include+lib
VPATH += /usr/local/lib /opt/local/lib

OS.PYTEST_FLAGS = --junit-xml pytest-tests.xml

OS.RPM_FLAGS    = --define "_tmppath /var/tmp"
OS.AUTO_CLEAN	= .DS_Store

PS2PDF = pstopdf

+vars:   $(.VARIABLES:%=+var[%])

clean:	clean-darwin
.PHONY: clean-darwin
clean-darwin:
	$(RM) -r *.dSYM
