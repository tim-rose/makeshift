#
# LIBRARY.MK: rules to build and install a library composed of a set of objects.
#
# Contents:
# build:           --build the library ".a"
# install-include: --install the include files, if any.
# archdir-LIB:     --Rules for building/updating the library.
# src-library:     --get a list of sub-directories that are libraries.
#
# Remarks:
# This is an attempt to manage a collection of object files (i.e. ".o" files)
# as an object library (i.e. ".a").  The library can be structured
# as a collection of "sub" libraries built from code in sub-directories.
# The top-level directory delegates building of the sub-libraries to
# recursive make targets, and then assembles them all into one
# master library.
#
# These rules require that LIB and OBJ are already defined (usually
# in the including makefile).
#
LIB_INCLUDEDIR=$(LIB_ROOT)/$(subdir)/include
LIB_INCLUDE_SRC = $(H_SRC:%.h=$(LIB_INCLUDEDIR)/%.h)

$(LIB_INCLUDEDIR):	;		$(INSTALL_DIRECTORY) $@
$(LIB_INCLUDEDIR)/%.h:	%.h;		$(INSTALL_FILE) $*.h $@

#
# libdir/%.a: --install rule for libraries
#
$(libdir)/%.a:	$(archdir)/%.a
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@
	$(RANLIB) $@

#
# pre-build: --Install the include files
#
pre-build:      $(LIB_INCLUDE_SRC)

#
# %/lib.a: --Build the library in its subdirectory.
#
%/$(archdir)/lib.a:     build@%;     $(ECHO_TARGET)

#
# build: --build the library ".a"
#
build:	var-defined[LIB_ROOT] var-defined[LIB] var-defined[LIB_OBJ] \
	$(archdir)/$(LIB)

#
# install-include: --install the include files, if any.
# install-lib:	--install the library files.
# install-man:	--install manual pages for the library
#
#install:	install-lib install-include install-man
install-include:	$(H_SRC:%.h=$(includedir)/%.h)
install-lib:		$(libdir)/$(LIB) install-include
install-man:		$(man3dir)/$(MAN3_SRC)

$(libdir)/$(LIB):	$(archdir)/$(LIB)

#
# archdir-LIB: --Rules for building/updating the library.
#
$(archdir)/$(LIB):	$(LIB_OBJ) $(SUBLIB_SRC)
	$(ECHO_TARGET)
	$(AR) $(ARFLAGS) $@ $(LIB_OBJ)
	ar-merge -v $@ $(SUBLIB_SRC)
	$(RANLIB) $@

clean:	clean-library

distclean: clean-library clean-include

clean-library:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(LIB)

clean-include:
	$(ECHO_TARGET)
	$(RM) $(LIB_INCLUDE_SRC)

#
# src-library: --get a list of sub-directories that are libraries.
#
src:	src-library
src-library:
	$(ECHO_TARGET)
	mk-filelist -qpn SUBLIB_SRC $$( \
	    grep -l '^include.* library.mk' */Makefile 2>/dev/null | \
	    while read file; do \
	        ( d=$$(dirname $$file); cd $$d >/dev/null && \
	        $(MAKE) -s print-lib-target| sed -e "s/^/$$d\//"; ) \
	    done)

#
# print-lib-target: --print the current library target in this directory
#
print-lib-target:	;	@echo "$(archdir)/$(LIB)"

+help:  +help-library
