#
# PACKAGE.MK--Build rules for packaging.
#
# Contents:
# package:         --Build a package for the current module.
# staging-root:    --Install the package in a staged root directory.
# release:         --Mark the current version of this package as "released".
# clean:           --Remove the tarball created by "dist", and the staging root.
# package-vars-ok: --Test that "PACKAGE" and other variables are defined.
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
# * RELEASE --additional identification tag.
#
# See Also:
# https://semver.org
#
PACKAGE ?= unknown
VERSION ?= local
RELEASE ?= latest

P-V	= $(PACKAGE)-$(VERSION)
PVR	= $(PACKAGE)_$(VERSION).$(RELEASE)
VRA	= $(VERSION).$(RELEASE)_$(ARCH)
PVRA	= $(PACKAGE)_$(VERSION).$(RELEASE)_$(ARCH)
STAGING_ROOT = staging-$(PACKAGE)
VCS_EXCLUDES = --exclude .git --exclude .svn

include $(package-type:%=package/%.mk)

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
staging-%:
	$(ECHO_TARGET)
	$(MAKE) install DESTDIR=$$(pwd)/$@ prefix=$(prefix) usr=$(usr) opt=$(opt)

#
# release: --Mark the current version of this package as "released".
#
release: vcs-tag[$(VERSION).$(RELEASE)]

#
# dist:	--Create a tar.gz distribution file.
#
# Remarks:
# This target execs another make to do a distclean before building the tar.gz.
# REVISIT: make sure symlink is cleaned up always!
#
dist:	package-vars-ok $(P-V).tar.gz
$(P-V).tar.gz:
	$(ECHO_TARGET)
	$(MAKE) distclean
	root=$$PWD; \
	    cd ..; ln -s $$root $(P-V); \
	    tar czf $(P-V).tar.gz --dereference $(VCS_EXCLUDES) $(P-V); \
	    $(RM) $(P-V); \
	    mv $(P-V).tar.gz $$root
#
# clean: --Remove the tarball created by "dist", and the staging root.
#
clean:	clean-package
distclean:	clean-package
clean-package:
	$(RM) $(P-V).tar.gz
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
