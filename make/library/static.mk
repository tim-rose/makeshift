#
# STATIC.MK: --Build this directory's static library.
#
a ?= a

#
# %/lib.a: --Build the sub-librar(ies) in its subdirectory.
#
%/$(archdir)/lib.$(a): | build@%;     $(ECHO_TARGET)

#
# build: --Build this directory's library.
#
build: $(archdir)/$(LIB_NAME).$(a)

#
# libdir/%.a: --Install a static (a) library
#
# Remarks:
# In the process of building, ".a" files are copied around a little,
# depending on the final composition/breakdown of sub-libraries.
#
$(libdir)/%.$(a):	$(archdir)/%.$(a)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(CROSS_COMPILE)$(RANLIB) $@
$(librootdir)/%.$(a):	$(archdir)/%.$(a)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(CROSS_COMPILE)$(RANLIB) $@
../$(archdir)/%.$(a):	$(archdir)/%.$(a)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(CROSS_COMPILE)$(RANLIB) $@

# install-lib-lib: --Install the library ".a" files only.
install-lib-lib:	install-lib-static-lib
install-lib-static-lib:	$(libdir)/$(LIB_NAME).$(a); $(ECHO_TARGET)

uninstall-lib-lib:	uninstall-lib-static-lib uninstall-lib-include
uninstall-lib-static-lib:
	$(ECHO_TARGET)
	$(RM) $(libdir)/$(LIB_NAME).$(a)
	$(RMDIR) $(libdir)

#
# archdir/%.a: --(re)build a library.
#
# Remarks:
# The only dependants listed here are the sub-libraries (if any), but
# the various <lang>-library.mk rules will add their language-specific
# objects as dependants too.
#
$(archdir)/lib.$(a): $(SUBLIB_SRC)
	$(ECHO_TARGET)
	mk-ar-merge -x $(CROSS_COMPILE)$(AR) $(ARFLAGS) $@ $^
	$(CROSS_COMPILE)$(RANLIB) $@

$(archdir)/$(LIB_NAME).$(a):	$(archdir)/lib.$(a)
	$(ECHO_TARGET)
	cp $< $@
	$(CROSS_COMPILE)$(RANLIB) $@
#
# clean: --Remove the library file.
#
clean:	clean-lib-static
clean-lib-static:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(LIB_NAME).$(a) $(archdir)/lib.$(a)
#
# src: --Get a list of sub-directories that are libraries.
#
# Remarks:
# This target "guesses" the sub-libraries by looking for Makefiles
# that include the "library.mk".
#
src:	src-lib-static
src-lib-static:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qpn SUBLIB_SRC $$( \
	    grep -l '^include.* library.mk' */*[Mm]akefile* 2>/dev/null | \
	    sed -e 's|/[^/]*[Mm]akefile.*|/$$(archdir)/lib.$(a)|g' | sort -u)
