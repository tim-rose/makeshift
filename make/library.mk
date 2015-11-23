#
# LIBRARY.MK: rules to build and install a library composed of a set of objects.
#
# Contents:
# libdir/%.a:          --Install a static (.a) library
# pre-build:           --Stage the include files.
# lib-obj-var-defined: --Test if "enough" of the library SRC variables are defined
# %/lib.a:             --Build the sub-librar(ies) in its subdirectory.
# build:               --Build this directory's library.
# lib-install-lib:     --Install the library (and include files).
# lib-install-include: --Install the library include files.
# lib-install-man:     --Install manual pages for the library.
# archdir/%.a:         --(re)build a library.
# clean:               --Remove the library file.
# distclean:           --Remove the include files installed at $LIB_ROOT/include.
# src:                 --Get a list of sub-directories that are libraries.
#
# Remarks:
# The "library" module provides rules for managing a collection of
# object files (i.e. ".o" files) as an object library (i.e. ".a").
# The library can be structured as a collection of "sub" libraries
# built from code in sub-directories.  The top-level directory
# delegates building of the sub-libraries to recursive make targets,
# and then assembles them all into one master library.
#
# These rules require that following variables are defined:
#
#  * LIB_ROOT --the root location of the main top-level library
#  * LIB      --the name of the library to build
#  * LIB_OBJ  --the objects to put into the library.
#
LIB_SUFFIX ?= a
LIB_PREFIX ?= lib

LIB_INCLUDEDIR=$(LIB_ROOT)/include/$(subdir)
LIB_INCLUDE_SRC = $(H_SRC:%=$(LIB_INCLUDEDIR)/%) \
    $(H++_SRC:%=$(LIB_INCLUDEDIR)/%)

$(LIB_INCLUDEDIR)/%:		%;		$(INSTALL_FILE) $* $@
$(LIB_INCLUDEDIR)/%:		$(archdir)/%;	$(INSTALL_FILE) $? $@

#
# libdir/%.a: --Install a static (.a) library
#
# Remarks:
# In the process of building, ".a" files are copied around a little,
# depending on the final composition/breakdown of sub-libraries.
#
$(libdir)/%.$(LIB_SUFFIX):	$(archdir)/%.$(LIB_SUFFIX)
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@
	$(RANLIB) $@
$(libbasedir)/%.$(LIB_SUFFIX):	$(archdir)/%.$(LIB_SUFFIX)
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@
	$(RANLIB) $@
../$(archdir)/%.$(LIB_SUFFIX):	$(archdir)/%.$(LIB_SUFFIX)
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@
	$(RANLIB) $@
#
# pre-build: --Stage the include files.
#
pre-build:      lib-src-var-defined $(LIB_INCLUDE_SRC)
build:		$(archdir)/$(LIB_PREFIX)$(LIB).$(LIB_SUFFIX)

#
# lib-obj-var-defined: --Test if "enough" of the library SRC variables are defined
#
lib-src-var-defined:
	@if [ -z '$(LIB_OBJ)$(SUBLIB_SRC)' ]; then \
	    printf $(VAR_UNDEF) 'LIB_OBJ or SUBLIB_SRC'; \
	    false; \
	fi >&2
#
# %/lib.a: --Build the sub-librar(ies) in its subdirectory.
#
%/$(archdir)/lib.a:     build@%;     $(ECHO_TARGET)

#
# build: --Build this directory's library.
#
build:	var-defined[LIB_ROOT] var-defined[LIB] lib-src-var-defined \
	$(archdir)/$(LIB_PREFIX)$(LIB).$(LIB_SUFFIX)

#
# lib-install-lib: --Install the library (and include files).
# lib-install-include: --Install the library include files.
# lib-install-man: --Install manual pages for the library.
#
lib-install-lib:	$(libdir)/$(LIB_PREFIX)$(LIB).$(LIB_SUFFIX) lib-install-include
lib-install-include:	$(H_SRC:%.h=$(includedir)/%.h)
lib-install-include:	$(H++_SRC:%=$(includedir)/%)
lib-install-man:	$(MAN3_SRC:%.3=$(man3dir)/%.3)

#
# archdir/%.a: --(re)build a library.
#
$(archdir)/lib.a:	$(LIB_OBJ) $(SUBLIB_SRC)
	$(ECHO_TARGET)
	mk-ar-merge $(ARFLAGS) $@ $(LIB_OBJ) $(SUBLIB_SRC)
	$(RANLIB) $@

$(archdir)/$(LIB_PREFIX)$(LIB).$(LIB_SUFFIX):	$(archdir)/lib.a
	$(ECHO_TARGET)
	cp $< $@
	$(RANLIB) $@

#
# clean: --Remove the library file.
#
clean:	lib-clean
lib-clean:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(LIB_PREFIX)$(LIB).$(LIB_SUFFIX) $(archdir)/lib.a

#
# distclean: --Remove the include files installed at $LIB_ROOT/include.
#
distclean: lib-clean lib-distclean
lib-distclean:
	$(ECHO_TARGET)
	$(RM) $(LIB_INCLUDE_SRC)

#
# src: --Get a list of sub-directories that are libraries.
#
src:	lib-src
lib-src:
	$(ECHO_TARGET)
	@mk-filelist -qpn SUBLIB_SRC $$( \
	    grep -l '^include.* library.mk' */Makefile 2>/dev/null | \
	    sed -e 's|Makefile|$$(archdir)/lib.a|g')
