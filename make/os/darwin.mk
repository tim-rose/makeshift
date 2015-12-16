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
OS.CFLAGS 	= -MMD
OS.C_WARN_FLAGS = -Wno-gnu-zero-variadic-macro-arguments
OS.C_CPPFLAGS   = -I/usr/local/include
OS.C_DEFS       = -D__Darwin__

OS.C++_CPPFLAGS = -I/usr/local/include -I/usr/include/c++/4.2.1
OS.C++_DEFS     = -D__Darwin__
OS.CXXFLAGS 	= -MMD
OS.LDFLAGS	= -stdlib=libstdc++ -Wl,-map,$(archdir)/$*.map
OS.PYTEST_FLAGS = --junit-xml pytest-tests.xml

OS.RPM_FLAGS    = --define "_tmppath /var/tmp"
OS.AUTO_CLEAN	= .DS_Store

CHMOD		= chmod
CP		= cp
GREP		= grep
INDENT          = gnuindent
MV		= mv
RANLIB		= ranlib

PKG_TYPE	= deb

+vars:   $(.VARIABLES:%=+var[%])

clean:	clean-darwin
.PHONY: clean-darwin
clean-darwin:
	$(RM) -r *.dSYM
