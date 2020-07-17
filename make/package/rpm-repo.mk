#
# rpm-repo.mk --Definitions for integrating an RPM repo into makeshift.
#
# Contents:
# package-rpm-repo:    --Build all the packages.
# package-rpm-repo[%]: --Build a single package.
# clean-rpm-repo:      --Remove the RPMs and other build artefacts.
# src-rpm-repo:        --Find the spec files in the SPECS part of the repo.
#
# Remarks:
# The package/rpm-repo module defines rules for processing a
# repository of RPM stuff, i.e. a collection of SOURCES, SPECS, RPMS
# etc. directories.
#
# The "package" rule builds all the RPMs defined by SPEC_SRC (by
# default SPECS/*.spec).
#
# See Also:
# https://fedoraproject.org/wiki/How_to_create_an_RPM_package
#
.PHONY: $(recursive-targets:%=%-rpm-repo)

DEFAULT_SPEC_SRC := $(subst SPECS/,,$(wildcard SPECS/*.spec))
SPEC_SRC ?= $(DEFAULT_SPEC_SRC)

RPMBUILD ?= rpmbuild
RPM_FLAGS = --define "_topdir $(CURDIR)" \
    $(OS.RPM_FLAGS) $(ARCH.RPM_FLAGS) \
    $(PROJECT.RPM_FLAGS) $(LOCAL.RPM_FLAGS) $(TARGET.RPM_FLAGS)

#
# package-rpm-repo: --Build all the packages.
#
package:	package-rpm-repo
package-rpm-repo:	$(SPEC_SRC:%=package-rpm-repo[%])

#
# package-rpm-repo[%]: --Build a single package.
#
package-rpm-repo[%]:
	$(RPMBUILD) -bb $(RPM_FLAGS) SPECS/$*
	$(RPMBUILD) -bs $(RPM_FLAGS) SPECS/$*

#
# clean-rpm-repo: --Remove the RPMs and other build artefacts.
#
clean:  clean-rpm-repo
distclean:  clean-rpm-repo
clean-rpm-repo:
	$(RM) -rf BUILD/* BUILDROOT/* RPMS/* SRPMS/*

#
# src-rpm-repo: --Find the spec files in the SPECS part of the repo.
#
src:	src-rpm-repo
src-rpm-repo:
	$(ECHO_TARGET)
	cd SPECS && mk-filelist -f../Makefile -qn SPEC_SRC *.spec
