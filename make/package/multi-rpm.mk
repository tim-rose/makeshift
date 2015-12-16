#
# MULTI-RPM.MK --Rules for building RPM sub-packages.
#
# Contents:
# rpm:            --Build an RPM of the package for the current version/release/arch.
# %-files.txt:    --Build a manifest file for the RPM's "file" section.
# rpm-version-ok: --Compare the ".spec" version with Makefile definitions.
# clean:          --Remove the RPM manifest file.
# distclean:      --Remove the RPM file.
#
# Remarks:
# TBD.
#
# See Also:
# https://fedoraproject.org/wiki/How_to_create_an_RPM_package
#
VERSION ?= local
RELEASE ?= latest

RPM_ARCH ?= $(shell mk-rpm-buildarch $(PACKAGE).spec)
P-V-R	= $(PACKAGE)-$(VERSION)-$(RELEASE)
V-R.A	= $(VERSION)-$(RELEASE).$(RPM_ARCH)
P-V-R.A	= $(PACKAGE)-$(VERSION)-$(RELEASE).$(RPM_ARCH)

RPMBUILD ?= rpmbuild
RPM_FLAGS = -bb --clean --define "_topdir $$PWD" \
    $(TARGET.RPM_FLAGS) $(LOCAL.RPM_FLAGS) $(PROJECT.RPM_FLAGS) \
    $(ARCH.RPM_FLAGS) $(OS.RPM_FLAGS)

package:	package-rpm

#
# rpm: --Build an RPM of the package for the current version/release/arch.
#
# Remarks:
# "package-rpm" and "rpm" are aliases, for convenience.
#
.PHONY:		package-rpm rpm
rpm package-rpm:	$(P-V-R.A).rpm

$(P-V-R.A).rpm: SPECS/$(PACKAGE).spec SOURCES/$(PACKAGE).spec
	$(RPMBUILD) $(RPM_FLAGS) SPECS/$(PACKAGE).spec
	$(MV) $(RPM_ARCH)/$(P-V-R.A).rpm $@

SPECS/%.spec:	.spec@%
	$(ECHO_TARGET)
	mkdir -p SPECS
	{ echo "Source: $(P-V).tar.gz"; cat $*/$*.spec; } >$@


.spec@%:
	cd $* >/dev/null && $(MAKE) $*.spec

%.spec:	spec %-rpm-files.txt
	{ echo "%define name $(PACKAGE)"; \
	echo "%define version $(VERSION)"; \
	echo "%define release $(RELEASE)"; \
	cat spec; \
        echo "%files"; \
	cat $*-rpm-files.txt; } > $@

#
# %-rpm-files.txt: --Build a manifest file for the RPM's "file" section.
#
# Remarks:
# This is defined as a pattern rule, so it can be overridden by
# an explicit rule if needed.
#
%-rpm-files.txt:	$(STAGING_ROOT)
	find $(STAGING_ROOT) -not -type d | \
            sed -e 's|^$(STAGING_ROOT)||' | mk-rpm-files >$@

clean:	clean-rpm
distclean:	clean-rpm distclean-rpm

#
# clean: --Remove the RPM manifest file.
#
.PHONY:	clean-rpm
clean-rpm:
	$(RM) -r -- rpm-files.txt $(RPM_ARCH)

#
# distclean: --Remove the RPM file.
#
.PHONY:	distclean-rpm
distclean-rpm:
	$(RM) $(P-V-R.A).rpm
