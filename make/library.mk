#
# LIBRARY.MK: rules to build and install a library composed of a set of objects.
#
# Contents:
# build()           --build the library ".a"
# install-include() --install the include files, if any.
# install-lib()     --install the library files.
# install-man()     --install manual pages for the library
# archdir-LIB()     --Rules for building/updating the library.
# build:            --build the library ".a"
# install-include:  --install the include files, if any.
# archdir-LIB:      --Rules for building/updating the library.
# libdir/%.a()      --install rule for libraries
# build()           --build the library ".a"
# install-include() --install the include files, if any.
# install-lib()     --install the library files.
# install-man()     --install manual pages for the library
# archdir-LIB()     --Rules for building/updating the library.
#
# Remarks:
# These rules require that LIB and OBJ are already defined (usually
# in the including makefile).
#

#
# libdir/%.a: --install rule for libraries
#
$(libdir)/%.a:	$(archdir)/%.a
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@

#
# build: --build the library ".a"
#
build: var-defined[LIB] var-defined[LIB_OBJ] $(archdir)/$(LIB)

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
$(archdir)/$(LIB):	$(LIB_OBJ)
	$(AR) $(ARFLAGS) $@ $?
	$(RANLIB) $@

clean:	clean-library
clean-library:
	$(RM) $(archdir)/$(LIB)
