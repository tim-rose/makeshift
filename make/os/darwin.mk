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
INDENT          = gnuindent

SH_PATH		= /bin/sh
AWK_PATH	= /usr/bin/awk
SED_PATH	= /usr/bin/sed -f
PERL_PATH	= /usr/bin/perl -f
PYTHON_PATH	= /usr/bin/python -f

c-clean:	clean-darwin
clean-darwin:
	$(RM) -r *.dSYM
