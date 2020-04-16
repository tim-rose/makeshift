#
# RPM.MK --Rules for building RPM packages.
#
# Contents:
# package-rpm:        --build a package in this directory.
# SPECS/package.spec: --Create the "real" spec file.
# srpm:               --Create a source RPM.
# %-rpm-files.txt:    --Build a manifest file for the RPM's "file" section.
# clean:              --Remove the RPM manifest file.
# distclean:          --Remove the RPM file.
#
# Remarks:
# The package/rpm module provides support for building an RPM package
# from the current source.
#
# The build process is controlled by the following make macros:
# * PACKAGE --the package to be built
# * VERSION --the version of the package (hopefully, a "semantic" version)
# * BUILD --a release tag to distinguish otherwise identical packages
#
# The module expecs to find a file $(PACKAGE).spec, which it expands
# into a "full" spec file in the SPECS sub-directory.  The rpmbuild
# process omits the setup step of "unpack a versioned tarball", it
# simply builds/installs from the current directory.
#
# Because the final file name(s) cannot be predicted, these package
# rules will re-run every time, re-creating the same results.
#
# See Also:
# https://fedoraproject.org/wiki/How_to_create_an_RPM_package
#
RPM_ARCH ?= $(shell mk-rpm-buildarch)
RPM_ARCH := $(RPM_ARCH)

RPMDIRS = BUILD BUILDROOT RPMS SOURCES SPECS SRPMS

RPMBUILD ?= rpmbuild
RPM_FLAGS = --define "_topdir $(CURDIR)" \
    $(TARGET.RPM_FLAGS) $(LOCAL.RPM_FLAGS) $(PROJECT.RPM_FLAGS) \
    $(ARCH.RPM_FLAGS) $(OS.RPM_FLAGS)

#
# package-rpm: --build a package in this directory.
#
.PHONY:		package-rpm rpm
package:	package-rpm
rpm:		package-rpm

package-rpm:	SPECS/$(PACKAGE).spec
	$(ECHO_TARGET)
	$(MKDIR) RPMS
	$(RPMBUILD) -bb $(RPM_FLAGS) SPECS/$(PACKAGE).spec

#
# SPECS/package.spec: --Create the "real" spec file.
#
# Remarks:
# This rule uses the ./package.spec as a template; it inserts a bunch
# of useful defines (especially: PACKAGE, VERSION, BUILD), and
# implementations for the RPM scriptlets: %build, %install, %clean.
# Note that there is no scriptlet for %setup: the current directory is
# assumed to be setup by its existence.
#
.PRECIOUS:	SPECS/$(PACKAGE).spec
SPECS/$(PACKAGE).spec:	$(PACKAGE).spec $(PACKAGE)-rpm-files.txt
	$(ECHO_TARGET)
	$(MKDIR) SPECS
	{ echo "%define name $(PACKAGE)"; \
	echo "%define version $(VERSION)"; \
	echo "%define release $(BUILD)"; \
	echo "%define _rpmdir %{_topdir}/RPMS"; \
	echo "%define _srcrpmdir %{_topdir}/SRPMS"; \
	echo "%define _specdir %{_topdir}"; \
	echo "%define _sourcedir %{_topdir}"; \
	echo "%define _patchdir %{_sourcedir}"; \
	echo "%define _builddir %{_sourcedir}"; \
	echo "BuildRoot: %{_tmppath}/BUILD"; \
	cat $<; \
	echo "%build"; \
	echo "make $(RPM_MAKEFLAGS) build prefix=$(prefix) usr=$(usr) opt=$(opt)"; \
	echo "%install"; \
	echo "make $(RPM_MAKEFLAGS) install-strip DESTDIR=\$$RPM_BUILD_ROOT prefix=$(prefix) usr=$(usr) opt=$(opt)"; \
	echo "%clean"; \
	echo "%{__rm} -rf \$$RPM_BUILD_ROOT"; \
        echo "%files"; \
	cat $(PACKAGE)-rpm-files.txt; } > $@

#
# Create the package's source tarball.
#
SOURCES/$(P-V).tar.gz:	$(P-V).tar.gz
	$(ECHO_TARGET)
	$(MKDIR) SOURCES
	ln $< $@

#
# srpm: --Create a source RPM.
#
# Remarks:
# Warning! this target creates the "dist" tarball, which involves
# a distclean of the current directory.
#
.PHONY: srpm
srpm:	SOURCES/$(P-V).tar.gz SPECS/$(PACKAGE).spec
	$(ECHO_TARGET)
	$(MKDIR) SRPMS
	$(RPMBUILD) -bs $(RPM_FLAGS) SPECS/$(PACKAGE).spec

#
# %-rpm-files.txt: --Build a manifest file for the RPM's "file" section.
#
# Remarks:
# This is defined as a pattern rule, so it can be overridden by
# an explicit rule if needed.
#
.PRECIOUS:	%-rpm-files.txt
%-rpm-files.txt:	$(DESTDIR_ROOT)
	$(ECHO_TARGET)
	find $(DESTDIR_ROOT) -not -type d | \
            sed -e 's|^$(DESTDIR_ROOT)||' | mk-rpm-files >$@

clean:	clean-rpm
distclean:	clean-rpm distclean-rpm

#
# clean: --Remove the RPM manifest file.
#
.PHONY:	clean-rpm
clean-rpm:
	$(RM) -r -- $(RPMDIRS:%=%/*) $(PACKAGE)-rpm-files.txt

#
# distclean: --Remove the RPM file.
#
.PHONY:	distclean-rpm
distclean-rpm:
	$(RM) -r -- $(RPMDIRS) $(P-V).tar.gz
