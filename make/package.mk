#
# PACKAGE.MK--Build rules for packaging.
#
# Contents:
# package:         --Build a package for the current module.
# staging-root:    --Install the package in a staged root directory.
# release:         --Mark the current version of this package as "released".
# distclean:       --Remove the tarball created by "dist".
# package-vars-ok: --Test that "PACKAGE" and other variables are defined.
#
# Remarks:
# The package module sets up some common definitions and then passes
# off to a package-specific makefile, which must define a top-level
# package-building rule named after the package type (i.e. "deb",
# "rpm", etc.).
#
PVR	= $(PACKAGE)_$(VERSION).$(RELEASE)
VRA	= $(VERSION).$(RELEASE)_$(ARCH)
PVRA	= $(PACKAGE)_$(VERSION).$(RELEASE)_$(ARCH)
STAGING_ROOT = $(PACKAGE)-staging-root

include $(package:%=package/%.mk)

#
# package: --Build a package for the current module.
#
package: package-vars-ok $(package:%=package-%)

#
# staging-root: --Install the package in a staged root directory.
#
# Remarks:
# This target is constructed as a pattern rule so that packages
# can override it.
#
.SECONDARY: $(STAGING_ROOT)
%-staging-root:
	$(ECHO_TARGET)
	$(MAKE) install DESTDIR=$$(pwd)/$@ prefix= usr=usr

#
# release: --Mark the current version of this package as "released".
#
release: vcs-tag[$(VERSION).$(RELEASE)]

#
# dist:	--Create a tar.gz distribution file.
#
# Remarks:
# This target execs another make to do a distclean before building the tar.gz.
#
dist:	package-vars-ok $(PVR).tar.gz
$(PVR).tar.gz:
	$(ECHO_TARGET)
	$(MAKE) distclean
	root=$$PWD; \
	    cd ..; ln -s $$root $(PVR); \
	    tar czf $(PVR).tar.gz -h $(VCS_EXCLUDES) $(PVR); \
	    $(RM) $(PVR); \
	    mv $(PVR).tar.gz $$root
#
# distclean: --Remove the tarball created by "dist".
#
distclean:	distclean-package
distclean-package:
	$(RM) $(PVR).tar.gz
	$(RM) -r $(STAGING_ROOT)

#
# package-vars-ok: --Test that "PACKAGE" and other variables are defined.
#
# Remarks:
# The "PACKAGE" variable is used to drive some of the packaging
# targets, so this rule prevents them from running (and failing)
# if PACKAGE is not defined.
#
.PHONY:		package-vars-ok
package-vars-ok:	var-defined[PACKAGE] var-defined[VERSION] var-defined[RELEASE]
