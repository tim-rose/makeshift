#
# PACKAGE.MK--Build rules for packaging.
#
# Contents:
# package:         --Build a package for the current module.
# release:         --Mark the current version of this package as "released".
# distclean:       --Remove the tarball created by "dist".
# package-vars-ok: --Test that "PACKAGE" and other variables are defined.
#
# Remarks:
# This sets up some common definitions and then passes off to a
# package-specific makefile, which must define a top-level
# package-building rule named after the package type (i.e. "deb",
# "rpm", etc.).  For now, I'm hard-coding the package type to
# "debian".
#
#PKG_TYPE= deb
VENDOR	= envato
PVR	= $(PACKAGE)_$(VERSION).$(RELEASE)
VRA	= $(VERSION).$(RELEASE)_$(ARCH)
PVRA	= $(PACKAGE)_$(VERSION).$(RELEASE)_$(ARCH)

include $(PKG_TYPE).mk

#
# package: --Build a package for the current module.
#
package: package-vars-ok $(PKG_TYPE)

#
# release: --Mark the current version of this package as "released".
#
release: version-match[$(VERSION).$(RELEASE)] vcs-tag[$(VERSION).$(RELEASE)]

#
# dist:	--Create a tar.gz distribution file.
#
# Remarks:
# This target execs another make to do a distclean before building the tar.gz.
#
dist:	package-vars-ok $(PVR).tar.gz
$(PVR).tar.gz:
	@$(ECHO) "++ make[$@]@$$PWD"
	$(MAKE) $(MFLAGS) distclean
	root=$$PWD; \
	    cd ..; ln -s $$root $(PVR); \
	    tar czf $(PVR).tar.gz -h $(VCS_EXCLUDES) $(PVR); \
	    $(RM) $(PVR); \
	    mv $(PVR).tar.gz $$root
#
# distclean: --Remove the tarball created by "dist".
#
distclean:	package-distclean
package-distclean:
	$(RM) $(PVR).tar.gz

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

#
#
#
publish:	var-defined[PACKAGE_DIR] $(PACKAGE_DIR)/$(PVRA).$(PKG_TYPE)

$(PACKAGE_DIR)/$(PVRA).$(PKG_TYPE):	$(PACKAGE_DIR) $(PVRA).$(PKG_TYPE)
	cp $(PVRA).$(PKG_TYPE) $@;
	cd $(PACKAGE_DIR); $(MAKE) -f $(DEVKIT_HOME)/include/repository.mk make clean; make all

