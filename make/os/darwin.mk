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
OS.C_CPPFLAGS = -I/usr/local/include
OS.C++_CPPFLAGS = -I/usr/local/include -I/usr/include/c++/4.2.1
OS.CXXFLAGS 	= -stdlib=libstdc++

RANLIB		= ranlib
GREP		= grep
PKG_TYPE	= deb
INDENT          = gnuindent

clean:	clean-darwin
.PHONY: clean-darwin
clean-darwin:
	$(RM) -r *.dSYM
