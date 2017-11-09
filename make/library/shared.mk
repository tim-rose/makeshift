#
# LIBRARY/SHARED.MK --Rules for building shared libraries.
#

#
# Define shared-library file extensions:
# * .so --a shared library
# * s.a --an ar(1) library of shared objects.
#
.so ?= so
.sa ?= s.a

#
# build: --Build this directory's shared library.
#
build: $(archdir)/$(LIB_NAME).$(.so)

#
# %/lib.so: --Build the sub-librar(ies) in its subdirectory.
#
%/$(archdir)/lib.$(.so): | build@%;     $(ECHO_TARGET)

#
# build: --Build this directory's library.
#
build: $(archdir)/$(LIB_NAME).$(.so)

#
# libdir/%.so: --Install a static (.so) library
#
# Remarks:
# In the process of building, ".so" files are copied around a little,
# depending on the final composition/breakdown of sub-libraries.
#
$(libdir)/%.$(.sa):	$(archdir)/%.$(.sa)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@
$(librootdir)/%.$(.sa):	$(archdir)/%.$(.sa)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@
../$(archdir)/%.$(.sa):	$(archdir)/%.$(.sa)
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@
	$(RANLIB) $@

# install-lib-lib: --Install the library ".so" files only.
install-lib-lib:	$(libdir)/$(LIB_NAME).$(.so); $(ECHO_TARGET)

uninstall-lib-lib:	uninstall-lib-include
	$(ECHO_TARGET)
	$(RM) $(libdir)/$(LIB_NAME).$(.so)
	$(RMDIR) -p $(libdir) 2>/dev/null || true

#
# archdir/%.so: --(re)build a library.
#
# Remarks:
# The only dependants listed here are the sub-libraries (if any), but
# the various <lang>-library.mk rules will add their language-specific
# objects as dependants too.
#
$(archdir)/lib.$(.sa): $(SUBLIB_SRC)
	$(ECHO_TARGET)
	mk-ar-merge $(ARFLAGS) $@ $^
	$(RANLIB) $@

$(archdir)/$(LIB_NAME).$(.so):	$(archdir)/lib.$(.sa)
	$(ECHO_TARGET)
	cp $< $@
	$(RANLIB) $@
#
# clean: --Remove the library file.
#
clean:	clean-lib
clean-lib:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(LIB_NAME).$(.so) $(archdir)/lib.$(.so)

#
# src: --Get a list of sub-directories that are libraries.
#
# Remarks:
# This target "guesses" the sub-libraries by looking for Makefiles
# that include the "library.mk".
#
src:	src-lib-dynamic
src-lib-dynamic:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qpn SUBLIB_SRC $$( \
	    grep -l '^include.* library.mk' */*[Mm]akefile* 2>/dev/null | \
	    sed -e 's|/[^/]*[Mm]akefile.*|/$$(archdir)/lib.$(.sa)|g' | sort -u)
