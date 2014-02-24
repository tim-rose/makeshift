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
# These rules require that LIB and OBJ are already defined (usually
# in the including makefile).
#
LIB_INCLUDEDIR=$(LIB_ROOT)/$(subdir)/include
LIB_INCLUDE_SRC = $(H_SRC:%=$(LIB_INCLUDEDIR)/%)

$(LIB_INCLUDEDIR):	;		$(INSTALL_DIRECTORY) $@
$(LIB_INCLUDEDIR)/%.h:	%.h;		$(INSTALL_FILE) $*.h $@
#$(LIB_INCLUDE_SRC):     mkdir[$(LIB_INCLUDEDIR)]

#
# libdir/%.a: --install rule for libraries
#
$(libdir)/%.a:	$(archdir)/%.a
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@
	$(RANLIB) $@

pre-build:      $(LIB_INCLUDE_SRC)

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
install-include:	$(H_SRC:%=$(includedir)/%)
install-lib:		$(libdir)/$(LIB) install-include
install-man:		$(man3dir)/$(MAN3_SRC)

$(libdir)/$(LIB):	$(archdir)/$(LIB)

installdirs:	$(libdir) $(includedir) $(man3dir)

#
# archdir-LIB: --Rules for building/updating the library.
#
$(archdir)/$(LIB):	$(LIB_OBJ) $(SUBLIB_SRC)
	$(ECHO_TARGET)
	$(AR) $(ARFLAGS) $@ $(LIB_OBJ)
	ar-merge -v $@ $(SUBLIB_SRC)
	$(RANLIB) $@

clean:	clean-library
clean-library:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(LIB) $(LIB_INCLUDE_SRC)


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

print-lib-target:	;	@echo "$(archdir)/$(LIB)"
