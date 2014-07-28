#
# DARWIN.MK	--Macros and definitions for macintosh OS X.
#
# Remarks:
# Libraries are a little quirky under darwin, and in particular,
# you can't move a library after building it.  ranlib(1) resets
# whatever needs to be done, and the build rules will apply
# it if defined.
#
C_OS_CPP_FLAGS = -I/usr/local/include
CXX_OS_CPP_FLAGS = -I/usr/local/include -I/usr/include/c++/4.2.1
CXX_OS_FLAGS 	= -std=c++98 -Wno-dollar-in-identifier-extension -Wno-c++11-long-long

RANLIB		= ranlib
GREP		= grep
PKG_TYPE	= deb
INDENT          = gnuindent


c-clean:	clean-darwin
clean-darwin:
	$(RM) -r *.dSYM
