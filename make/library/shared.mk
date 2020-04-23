#
# LIBRARY/SHARED.MK --Rules for building shared libraries.
#
# Remarks:
# This is currently a bit deficient; some shared libraries
# need to list their dependent libraries...
#

#
# Define shared-library file extensions:
# * .so --a shared library
# * s.a --an ar(1) library of shared objects.
#
so ?= so
s.a ?= s.a

#
# %/lib.s.a: --Build the sub-librar(ies) in its subdirectory.
#
%/$(archdir)/lib.$(s.a): | build@%;     $(ECHO_TARGET)
%/$(archdir)/lib.$(so):  | build@%;     $(ECHO_TARGET)

#
# build: --Build this directory's library.
#
build: $(archdir)/$(LIB_NAME).$(so)

#
# libdir/%.so: --Install a static (so) library
#
# Remarks:
# In the process of building, ".so" files are copied around a little,
# depending on the final composition/breakdown of sub-libraries.
#
$(libdir)/%.$(s.a):	$(archdir)/%.$(s.a)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@
$(librootdir)/%.$(s.a):	$(archdir)/%.$(s.a)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@
../$(archdir)/%.$(s.a):	$(archdir)/%.$(s.a)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@

# install-lib-lib: --Install the library ".so" files only.
install-lib-lib:	$(libdir)/$(LIB_NAME).$(so); $(ECHO_TARGET)

uninstall-lib-lib:	uninstall-lib-include
	$(ECHO_TARGET)
	$(RM) $(libdir)/$(LIB_NAME).$(so)
	$(RMDIR) -p $(libdir) 2>/dev/null ||:

#
# archdir/%.so: --(re)build a library.
#
# Remarks:
# The only dependants listed here are the sub-libraries (if any), but
# the various <lang>-library.mk rules will add their language-specific
# objects as dependants too.
#
$(archdir)/lib.$(s.a): $(SUBLIB_SRC:%.$(a)=%.$(s.a))
	$(ECHO_TARGET)
	mk-ar-merge $(ARFLAGS) $@ $^
	$(RANLIB) $@

#
# REVISIT: ld -install_name? -rpath? c.f: install_name_tool
#
$(archdir)/$(LIB_NAME).$(so):	$(archdir)/lib.$(s.a)
	$(ECHO_TARGET)
	$(MKDIR) $(tmpdir)
	$(LN) $< $(tmpdir)
	cd $(tmpdir) && $(AR) x lib.$(s.a)
	$(LD) $(LD_SHARED_FLAGS) -o $@ $(tmpdir)/*.$(s.o)
	$(RM) -r $(tmpdir)
#
# clean: --Remove the library file.
#
clean:	clean-lib-shared
clean-lib-shared:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(LIB_NAME).$(so) $(archdir)/lib.$(so)
