#
# DARWIN.MK	--Macros and definitions for macintosh OS X.
#
# Remarks:
# Libraries are a little quirky under darwin, and in particular,
# you can't move a library after building it.  ranlib(1) resets
# whatever needs to be done, and the build rules will apply
# it if defined.
#
C_OS_DEFS 	= -D__Darwin__

CXX_OS_DEFS 	= -D__Darwin__

RANLIB		= ranlib
GREP		= grep
PKG_TYPE	= deb

PERL_PATH	= /usr/bin/perl
PYTHON_PATH	= /usr/bin/python
SH_PATH		= /bin/sh

clean:	clean-darwin
clean-darwin:
	$(RM) -r *.dSYM
