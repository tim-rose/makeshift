#
# PACKAGE.MK--Build rules for packaging.
#
# Contents:
# package:   --Build a package for the current module.
# staging-%: --Install the package in a staged root directory.
# clean:     --Remove the tarball created by "dist", and the destdir root.
#
# Remarks:
# The package module sets up some common definitions and then passes
# off to a package-specific makefile, which must define a top-level
# package-building rule named after the package type (i.e. "deb",
# "rpm", etc.).
#
# The make variable `package-type` controls which packages are built, e.g.
#
#     package-type = rpm deb
#
# The full name of the generated package is defined by three make variables:
#
# * PACKAGE --the name of the package
# * VERSION --(ideally a three-number triple updated "semantically")
# * BUILD --build identifier (derived from environment?).
#
# See Also:
# https://semver.org
#
# TODO: Add support for building Windows ".msi" packages.
#
LOCAL_PACKAGE := $(notdir $(CURDIR))
PACKAGE ?= $(LOCAL_PACKAGE)

P-V	= $(PACKAGE)$(VERSION:%=-%)
P_V.B	= $(PACKAGE)$(VERSION:%=_%)$(BUILD:%=.%)

DESTDIR_ROOT = staging-$(PACKAGE)
VCS_EXCLUDES = --exclude .git --exclude .svn

include $(package-type:%=package/%.mk)

#
# package: --Build a package for the current module.
#
package: $(package:%=package-%)

#
# staging-%: --Install the package in a staged root directory.
#
# Remarks:
# This target is constructed as a pattern rule so that packages
# can override it.
#
.SECONDARY: $(DESTDIR_ROOT)
staging-%:
	$(ECHO_TARGET)
	$(MAKE) install DESTDIR=$$(pwd)/$@ prefix=$(prefix) usr=$(usr) opt=$(opt)

#
# dist:	--Create a tar.gz distribution file.
#
# Remarks:
# This target execs another make to do a distclean before building the tar.gz.
# REVISIT: make sure symlink is cleaned up always!
# TODO: this is a std target, migrate it to makeshift.mk
#
dist:	$(P-V).tar.gz
$(P-V).tar.gz:
	$(ECHO_TARGET)
	$(MAKE) distclean
	root=$$PWD; \
	    cd ..; ln -s $$root $(P-V); \
	    tar czf $(P-V).tar.gz --dereference $(VCS_EXCLUDES) $(P-V); \
	    $(RM) -- $(P-V); \
	    $(MV) $(P-V).tar.gz $$root
#
# clean: --Remove the tarball created by "dist", and the destdir root.
#
clean:	clean-package
distclean:	clean-package
clean-package:
	$(RM) -- $(P-V).tar.gz
	$(RM) -r -- $(DESTDIR_ROOT)
