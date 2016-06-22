#
# LIBRARY.MK: rules to build and install a library composed of a set of objects.
#
# Contents:
# libdir/%.a:          --Install a static (.a) library
# pre-build:           --Stage the include files.
# lib-src-defined:     --Test if "enough" of the library SRC variables are defined.
# %/lib.a:             --Build the sub-librar(ies) in its subdirectory.
# build:               --Build this directory's library.
# install-lib-lib:     --Install the library (and include files).
# install-lib-include: --Install the library include files.
# install-lib-man:     --Install manual pages for the library.
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
# These rules are controlled by the following macros:
#
#  * LIB_ROOT --the root location of the main top-level library (default: ".")
#  * LIB      --the name of the library to build (default: name of current dir)
#  * LIB_OBJ  --the objects to put into the library (default: C/C++ objects)
#
LIB_SUFFIX	?= a
LIB_PREFIX	?= lib
LOCAL_LIB	:= $(subst lib,,$(notdir $(PWD)))
LIB		?= $(LOCAL_LIB)

LIB_NAME	= $(LIB_PREFIX)$(LIB).$(LIB_SUFFIX)
LIB_ROOT	?= .
LIB_OBJ		?= $(C_OBJ) $(C++_OBJ) $(LEX_OBJ) $(YACC_OBJ) \
                   $(QTR_OBJ) $(XSD_OBJ) $(PROTOBUF_OBJ)

LIB_INCLUDEDIR = $(LIB_ROOT)/include/$(subdir)
LIB_INCLUDE_SRC = $(H_SRC:%=$(LIB_INCLUDEDIR)/%) \
    $(H++_SRC:%=$(LIB_INCLUDEDIR)/%) \
    $(YACC_SRC:%.y=$(LIB_INCLUDEDIR)/%.h) \
    $(PROTOBUF_SRC:%.proto=$(LIB_INCLUDEDIR)/%.pb.$(H++_SUFFIX))

#
# Pattern rules for doing a staged install of the library's ".h" files.
#
$(LIB_INCLUDEDIR)/%:		$(archdir)/%;	$(INSTALL_FILE) $? $@
$(LIB_INCLUDEDIR)/%:		%;		$(INSTALL_FILE) $* $@

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
pre-build:      lib-src-defined $(LIB_INCLUDE_SRC)

#
# lib-src-defined: --Test if "enough" of the library SRC variables are defined.
#
lib-src-defined:
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
build: $(archdir)/$(LIB_NAME) | lib-src-defined

#
# install-lib-lib: --Install the library (and include files).
# install-lib-include: --Install the library include files.
# install-lib-man: --Install manual pages for the library.
#
.PHONY: install-lib-lib install-lib-include install-lib-man
install-lib-lib:	$(libdir)/$(LIB_NAME) install-lib-include; $(ECHO_TARGET)
install-lib-include:	$(H_SRC:%.h=$(includedir)/%.h) \
    $(H++_SRC:%=$(includedir)/%) \
    $(YACC_SRC:%.y=$(includedir)/%.h)
	$(ECHO_TARGET)

install-lib-man:	$(MAN3_SRC:%.3=$(man3dir)/%.3); $(ECHO_TARGET)

.PHONY: uninstall-lib-lib uninstall-lib-include uninstall-lib-man
uninstall-lib-lib:	uninstall-lib-include
	$(ECHO_TARGET)
	$(RM) $(libdir)/$(LIB_NAME)
	$(RMDIR) -p $(libdir) 2>/dev/null || true

uninstall-lib-include:
	$(ECHO_TARGET)
	$(RM) $(H_SRC:%=$(includedir)/%) $(H++_SRC:%=$(includedir)/%) $(YACC_SRC:%=$(LIB_INCLUDEDIR)/%)
	$(RMDIR) -p $(includedir) 2>/dev/null || true

uninstall-lib-man:
	$(ECHO_TARGET)
	$(RM) $(MAN3_SRC:%.3=$(man3dir)/%.3)
	$(RMDIR) -p $(man3dir) 2>/dev/null || true

#
# archdir/%.a: --(re)build a library.
#
$(archdir)/lib.a:	$(LIB_OBJ) $(SUBLIB_SRC)
	$(ECHO_TARGET)
	mk-ar-merge $(ARFLAGS) $@ $(LIB_OBJ) $(SUBLIB_SRC)
	$(RANLIB) $@

$(archdir)/$(LIB_NAME):	$(archdir)/lib.a
	$(ECHO_TARGET)
	cp $< $@
	$(RANLIB) $@

#
# clean: --Remove the library file.
#
clean:	clean-lib
clean-lib:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(LIB_NAME) $(archdir)/lib.a

#
# distclean: --Remove the include files installed at $LIB_ROOT/include.
#
distclean: clean-lib distclean-lib
distclean-lib:
	$(ECHO_TARGET)
	if [ "$(LIB_ROOT)" = "." ]; then $(RM) -r $(LIB_INCLUDEDIR); fi

#
# src: --Get a list of sub-directories that are libraries.
#
src:	src-lib
src-lib:
	$(ECHO_TARGET)
	@mk-filelist -qpn SUBLIB_SRC $$( \
	    grep -l '^include.* library.mk' */Makefile 2>/dev/null | \
	    sed -e 's|Makefile|$$(archdir)/lib.a|g')
