#
# LIBRARY.MK: rules to build and install a library composed of a set of objects.
#
# Contents:
# libdir/%.a:          --Install a static (.a) library
# pre-build:           --Stage the include files.
# %/lib.a:             --Build the sub-librar(ies) in its subdirectory.
# build:               --Build this directory's library.
# install-lib:         --Install all the library components
# install-lib-lib:     --Install the library ".a", ".so" files only.
# install-lib-include: --Install the library include files only.
# install-lib-man:     --Install manual pages for the library only.
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
export library-type ?= static
include $(library-type:%=library/%.mk)

#
# Pattern rules for doing a staged install of the library's ".h" files.
#
$(LIB_INCLUDEDIR)/%:		$(archdir)/%;	$(INSTALL_RDONLY) $? $@
$(LIB_INCLUDEDIR)/%:		$(gendir)/%;	$(INSTALL_RDONLY) $? $@
$(LIB_INCLUDEDIR)/%:		%;		$(INSTALL_RDONLY) $* $@
#
# Respecify pattern rules to avoid the trailing // if subdir is empty,
# so that dependencies can be declared more naturally (otherwise make
# would only match "lib_root/include//dependant.h").
#
$(LIB_ROOT)/include/%:		$(archdir)/%;	$(INSTALL_RDONLY) $? $@
$(LIB_ROOT)/include/%:		$(gendir)/%;	$(INSTALL_RDONLY) $? $@
$(LIB_ROOT)/include/%:		%;		$(INSTALL_RDONLY) $* $@

#
# pre-build: --Stage the include files.
#
pre-build:	pre-build-lib
pre-build-lib:;$(ECHO_TARGET)


#
# install-lib: --Install all the library components
# install-lib-lib: --Install the library ".a", ".so" files only.
# install-lib-include: --Install the library include files only.
# install-lib-man: --Install manual pages for the library only.
#
# Remarks:
# The include files are (un)installed by language-specific rules
# that are dependants of these targets.
#
.PHONY: install-lib install-lib-lib install-lib-include install-lib-man
install-lib:	install-lib-lib install-lib-include install-lib-man; $(ECHO_TARGET)
install-lib-include:; $(ECHO_TARGET)

install-lib-man:	$(MAN3_SRC:%.3=$(man3dir)/%.3); $(ECHO_TARGET)

.PHONY: uninstall-lib uninstall-lib-lib uninstall-lib-include uninstall-lib-man
uninstall-lib: uninstall-lib-lib uninstall-lib-include uninstall-lib-man

uninstall-lib-include:
	$(ECHO_TARGET)
	$(RMDIR) -p $(includedir) 2>/dev/null || true

uninstall-lib-man:
	$(ECHO_TARGET)
	$(RM) $(MAN3_SRC:%.3=$(man3dir)/%.3)
	$(RMDIR) -p $(man3dir) 2>/dev/null || true

#
# distclean: --Remove the include files installed at $LIB_ROOT/include.
#
distclean: clean-lib distclean-lib
distclean-lib:
	$(ECHO_TARGET)
	$(RMDIR) -p $(LIB_INCLUDEDIR) 2>/dev/null || true
