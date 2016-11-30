#
# LIBRARY.MK: rules to build and install a library composed of a set of objects.
#
# Contents:
# libdir/%.a:          --Install a static (.a) library
# pre-build:           --Stage the include files.
# %/lib.a:             --Build the sub-librar(ies) in its subdirectory.
# build:               --Build this directory's library.
# install-lib-lib:     --Install the library (and include files).
# install-lib-include: --Install the library include files.
# install-lib-man:     --Install manual pages for the library.
# archdir/%.a:         --(re)build a library.
# archdir/%.so:        --(re)build a shared library.
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
# These rules are controlled by the following macros:
#
#  * LIB_ROOT --the root location of the main top-level library (default: ".")
#  * LIB      --the name of the library to build (default: name of current dir)
#
# The list of objects to add to the library are defined as the dependants
# of the library target, and these are added to by language-specific
# definitions. See c-library.mk for example.
#
LIB_SUFFIX	?= a
LIB_SHARED_SUFFIX ?= .so
LIB_PREFIX	?= lib
LOCAL_LIB	:= $(subst lib,,$(notdir $(CURDIR)))
LIB		?= $(LOCAL_LIB)

LIB_NAME	= $(LIB_PREFIX)$(LIB)
LIB_ROOT	?= .

LIB_INCLUDEDIR = $(LIB_ROOT)/include/$(subdir)

-include $(language:%=lang/%-library.mk)

#
# Include custom rules for the type(s) of library to build
#
export library ?= static
#include $(library:%=library-%.mk)

#
# Pattern rules for doing a staged install of the library's ".h" files.
#
$(LIB_INCLUDEDIR)/%:		$(archdir)/%;	$(INSTALL_DATA) $? $@
$(LIB_INCLUDEDIR)/%:		$(gendir)/%;	$(INSTALL_DATA) $? $@
$(LIB_INCLUDEDIR)/%:		%;		$(INSTALL_DATA) $* $@

#
# libdir/%.a: --Install a static (.a) library
#
# Remarks:
# In the process of building, ".a" files are copied around a little,
# depending on the final composition/breakdown of sub-libraries.
#
$(libdir)/%.$(LIB_SUFFIX):	$(archdir)/%.$(LIB_SUFFIX)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@
$(libbasedir)/%.$(LIB_SUFFIX):	$(archdir)/%.$(LIB_SUFFIX)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@
../$(archdir)/%.$(LIB_SUFFIX):	$(archdir)/%.$(LIB_SUFFIX)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@
#
# pre-build: --Stage the include files.
#
pre-build:      pre-build-lib
pre-build-lib:;$(ECHO_TARGET)

#
# %/lib.a: --Build the sub-librar(ies) in its subdirectory.
#
%/$(archdir)/lib.$(LIB_SUFFIX):     build@%;     $(ECHO_TARGET)

#
# build: --Build this directory's library.
#
build: $(archdir)/$(LIB_NAME).$(LIB_SUFFIX)

#
# install-lib-lib: --Install the library (and include files).
# install-lib-include: --Install the library include files.
# install-lib-man: --Install manual pages for the library.
#
# Remarks:
# The include files are (un)installed by language-specific rules
# that are dependants of these targets.
#
.PHONY: install-lib-lib install-lib-include install-lib-man
install-lib-lib:	$(libdir)/$(LIB_NAME).$(LIB_SUFFIX) install-lib-include; $(ECHO_TARGET)
install-lib-include:; $(ECHO_TARGET)

install-lib-man:	$(MAN3_SRC:%.3=$(man3dir)/%.3); $(ECHO_TARGET)

.PHONY: uninstall-lib-lib uninstall-lib-include uninstall-lib-man
uninstall-lib-lib:	uninstall-lib-include
	$(ECHO_TARGET)
	$(RM) $(libdir)/$(LIB_NAME).$(LIB_SUFFIX)
	$(RMDIR) -p $(libdir) 2>/dev/null || true

uninstall-lib-include:
	$(ECHO_TARGET)
	$(RMDIR) -p $(includedir) 2>/dev/null || true

uninstall-lib-man:
	$(ECHO_TARGET)
	$(RM) $(MAN3_SRC:%.3=$(man3dir)/%.3)
	$(RMDIR) -p $(man3dir) 2>/dev/null || true

#
# archdir/%.a: --(re)build a library.
#
# Remarks:
# The only dependants listed here are the sub-libraries (if any), but
# the various <lang>-library.mk rules will add their language-specific
# objects as dependants too.
#
$(archdir)/lib.$(LIB_SUFFIX): $(SUBLIB_SRC)
	$(ECHO_TARGET)
	mk-ar-merge $(ARFLAGS) $@ $^
	$(RANLIB) $@

$(archdir)/$(LIB_NAME).$(LIB_SUFFIX):	$(archdir)/lib.$(LIB_SUFFIX)
	$(ECHO_TARGET)
	cp $< $@
	$(RANLIB) $@

#
# archdir/%.so: --(re)build a shared library.
#
$(archdir)/lib.so.a: $(SUBLIB_SRC)
	$(ECHO_TARGET)
	mk-ar-merge $(ARFLAGS) $@ $^

#
# clean: --Remove the library file.
#
clean:	clean-lib
clean-lib:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(LIB_NAME).$(LIB_SUFFIX) $(archdir)/lib.$(LIB_SUFFIX)

#
# distclean: --Remove the include files installed at $LIB_ROOT/include.
#
distclean: clean-lib distclean-lib
distclean-lib:
	$(ECHO_TARGET)
	$(RMDIR) -p $(LIB_INCLUDEDIR) 2>/dev/null || true

#
# src: --Get a list of sub-directories that are libraries.
#
src:	src-lib
src-lib:
	$(ECHO_TARGET)
	@mk-filelist -qpn SUBLIB_SRC $$( \
	    grep -l '^include.* library.mk' */Makefile 2>/dev/null | \
	    sed -e 's|Makefile|$$(archdir)/lib.a|g')
