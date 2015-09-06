#
# RPM.MK --Rules for building RPM packages.
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
BUILD_ARCH ?= $(shell mk-rpm-buildarch $(PACKAGE).spec)
P-V-R	= $(PACKAGE)-$(VERSION)-$(RELEASE)
V-R.A	= $(VERSION)-$(RELEASE).$(BUILD_ARCH)
P-V-R.A	= $(PACKAGE)-$(VERSION)-$(RELEASE).$(BUILD_ARCH)

package:	package-rpm

#
# rpm: --Build an RPM of the package for the current version/release/arch.
#
# Remarks:
# "package-rpm" and "rpm" are aliases, for convenience.
#
.PHONY:		package-rpm rpm
package-rpm:	package-vars-ok rpm
rpm:		$(P-V-R.A).rpm

$(P-V-R.A).rpm: $(PACKAGE).spec $(PACKAGE)-files.txt cmd-exists[rpmbuild]
	rpmbuild -bb --clean $(PACKAGE).spec --define '_tmppath $(pwd)/tmp'
	$(MV) $(BUILD_ARCH)/$(P-V-R.A).rpm $@

#
# %-files.txt: --Build a manifest file for the RPM's "file" section.
#
# Remarks:
# This is defined as a pattern rule, so it can be overridden by
# an explicit rule if needed.
#
%-files.txt:	$(STAGING_ROOT)
	find $(STAGING_ROOT) -not -type d | \
            sed -e 's|^$(STAGING_ROOT)||' | mk-rpm-files >$@

#
# rpm-version-ok: --Compare the ".spec" version with Makefile definitions.
#
release:	rpm-version-ok[$(VERSION)] rpm-release-ok[$(RELEASE)]
rpm-version-ok[%]:
	$(ECHO_TARGET)
	@$(GREP)  'Version: *$*' $(PACKAGE).spec >/dev/null 2>&1

rpm-release-ok[%]:
	$(ECHO_TARGET)
	@$(GREP)  'Release: *$*' $(PACKAGE).spec >/dev/null 2>&1



clean:	clean-rpm
distclean:	clean-rpm distclean-rpm

#
# clean: --Remove the RPM manifest file.
#
.PHONY:	clean-rpm
clean-rpm:
	$(RM) -r $(PACKAGE)-files.txt $(BUILD_ARCH)

#
# distclean: --Remove the RPM file.
#
.PHONY:	distclean-rpm
distclean-rpm:
	$(RM) $(P-V-R.A).rpm
