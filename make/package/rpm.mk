#
# RPM.MK --Rules for building RPM sub-packages.
#
# Contents:
# rpm:                 --Build an RPM package for the current source.
# rpm[%]:              --Build a sub-package from shared source.
# SPECS/package-%.spec: --Create the "sub-component" spec file.
# SPECS/package.spec:  --Create the overall spec file.
# spec[%]:             --Recursively build a sub-component's spec file.
# %-rpm-files.txt:     --Build a manifest file for the RPM's "file" section.
# clean:               --Remove the RPM manifest file.
# distclean:           --Remove the RPM file.
#
# Remarks:
# The package/rpm module provides support for building an RPM package
# from the current source.
#
# The build process is controlled by the following
#
# See Also:
# https://fedoraproject.org/wiki/How_to_create_an_RPM_package
#
RPM_DEFAULT_ARCH := $(shell mk-rpm-buildarch)
RPM_ARCH ?= $(RPM_DEFAULT_ARCH)

P-V-R	= $(PACKAGE)-$(VERSION)-$(RELEASE)
V-R.A	= $(VERSION)-$(RELEASE).$(RPM_ARCH)
P-V-R.A	= $(PACKAGE)-$(VERSION)-$(RELEASE).$(RPM_ARCH)

#
# rpmbuild configuration
#
RPMBUILD ?= rpmbuild
RPM_FLAGS = --clean --define "_topdir $$PWD" \
    $(TARGET.RPM_FLAGS) $(LOCAL.RPM_FLAGS) $(PROJECT.RPM_FLAGS) \
    $(ARCH.RPM_FLAGS) $(OS.RPM_FLAGS)

#
# rpm: --Build an RPM package for the current source.
#
.PHONY:		package-rpm rpm rpm[.]
package:	package-rpm
package-rpm:	rpm

rpm:	$(RPM_PACKAGES:%=rpm[%]) rpm[.]
#
# rpm[.]: --build a package in this directory.
#
rpm[.]:	SPECS/$(PACKAGE).spec
	$(ECHO_TARGET)
	mkdir -p RPMS
	$(RPMBUILD) -bb $(RPM_FLAGS) SPECS/$(PACKAGE).spec

#
# rpm[%]: --Build a sub-package from shared source.
#
rpm[%]:	SOURCES/$(P-V).tar.gz SPECS/$(PACKAGE)-%.spec
	$(ECHO_TARGET)
	mkdir -p RPMS
	$(RPMBUILD) -bb $(RPM_FLAGS) SPECS/$(PACKAGE)-$*.spec

#
# SPECS/package-%.spec: --Create the "sub-component" spec file.
#
# REVISIT: DRY spec-file production...
#
.PRECIOUS:	SPECS/$(PACKAGE)-%.spec
SPECS/$(PACKAGE)-%.spec:	spec[%]
	$(ECHO_TARGET)
	mkdir -p SPECS
	{ echo "%define name $(PACKAGE)-$*"; \
	echo "%define version $(VERSION)"; \
	echo "%define release $(RELEASE)"; \
	echo "%define _rpmdir %{_topdir}/RPMS"; \
	echo "%define _srcrpmdir %{_topdir}/SRPMS"; \
	echo "%define _specdir %{_topdir}"; \
	echo "%define _sourcedir %{_topdir}"; \
	echo "%define _patchdir %{_sourcedir}"; \
	echo "%define _builddir %{_sourcedir}"; \
	echo "BuildRoot: %{_tmppath}/BUILD"; \
	echo "Source: $(P-V).tar.gz"; \
	cat $*/$*.spec; \
	echo "%build"; \
	echo "cd $*"; \
	echo "make $(RPM_MAKEFLAGS) build DESTDIR=\$$RPM_BUILD_ROOT prefix=$(prefix) usr=$(usr) opt=$(opt)"; \
	echo "%install"; \
	echo "cd $*"; \
	echo "make $(RPM_MAKEFLAGS) install DESTDIR=\$$RPM_BUILD_ROOT prefix=$(prefix) usr=$(usr) opt=$(opt)"; \
	echo "%clean"; \
	echo "%{__rm} -rf \$$RPM_BUILD_ROOT"; \
        echo "%files"; \
	cat $*/$*-rpm-files.txt; } > $@

#
# SPECS/package.spec: --Create the overall spec file.
#
.PRECIOUS:	SPECS/$(PACKAGE).spec
SPECS/$(PACKAGE).spec:	$(PACKAGE).spec $(PACKAGE)-rpm-files.txt
	$(ECHO_TARGET)
	mkdir -p SPECS
	{ echo "%define name $(PACKAGE)"; \
	echo "%define version $(VERSION)"; \
	echo "%define release $(RELEASE)"; \
	echo "%define _rpmdir %{_topdir}/RPMS"; \
	echo "%define _srcrpmdir %{_topdir}/SRPMS"; \
	echo "%define _specdir %{_topdir}"; \
	echo "%define _sourcedir %{_topdir}"; \
	echo "%define _patchdir %{_sourcedir}"; \
	echo "%define _builddir %{_sourcedir}"; \
	echo "BuildRoot: %{_tmppath}/BUILD"; \
	cat $<; \
	echo "%build"; \
	echo "make $(RPM_MAKEFLAGS) build DESTDIR=\$$RPM_BUILD_ROOT prefix=$(prefix) usr=$(usr) opt=$(opt)"; \
	echo "%install"; \
	echo "make $(RPM_MAKEFLAGS) install DESTDIR=\$$RPM_BUILD_ROOT prefix=$(prefix) usr=$(usr) opt=$(opt)"; \
	echo "%clean"; \
	echo "%{__rm} -rf \$$RPM_BUILD_ROOT"; \
        echo "%files"; \
	cat $(PACKAGE)-rpm-files.txt; } > $@

#
# spec[%]: --Recursively build a sub-component's spec file.
#
spec[%]:
	$(ECHO_TARGET)
	$(MAKE) build
	$(MAKE) --directory $* SPECS/$*.spec

#
# Create the package's source tarball.
#
SOURCES/$(P-V).tar.gz:	$(P-V).tar.gz | mkdir[SOURCES]
	$(ECHO_TARGET)
	ln $< $@

.PHONY: srpm
srpm:	SRPMS/$(P-V-R).src.rpm
SRPMS/$(P-V-R).src.rpm:	SOURCES/$(P-V).tar.gz SPECS/$(PACKAGE).spec
	$(ECHO_TARGET)
	mkdir -p SRPMS
	$(RPMBUILD) -bs $(RPM_FLAGS) SPECS/$(PACKAGE).spec

#
# %-rpm-files.txt: --Build a manifest file for the RPM's "file" section.
#
# Remarks:
# This is defined as a pattern rule, so it can be overridden by
# an explicit rule if needed.
#
.PRECIOUS:	%-rpm-files.txt
%-rpm-files.txt:	$(STAGING_ROOT)
	$(ECHO_TARGET)
	find $(STAGING_ROOT) -not -type d | \
            sed -e 's|^$(STAGING_ROOT)||' | mk-rpm-files >$@

clean:	clean-rpm
distclean:	clean-rpm distclean-rpm

#
# clean: --Remove the RPM manifest file.
#
.PHONY:	clean-rpm
clean-rpm:
	$(RM) -r BUILD BUILDROOT $(PACKAGE)-rpm-files.txt

#
# distclean: --Remove the RPM file.
#
.PHONY:	distclean-rpm
distclean-rpm:
	$(RM) -r SPECS SOURCES RPMS SRPMS $(P-V).tar.gz
