#
# rpm-repo.mk --Definitions for integrating an RPM repo into devkit.
#
.PHONY: $(recursive-targets:%=%-rpm-repo)

DEFAULT_SPEC_SRC := $(subst SPECS/,,$(wildcard SPECS/*.spec))
SPEC_SRC ?= $(DEFAULT_SPEC_SRC)

RPMBUILD = rpmbuild
RPM_FLAGS = --define "_topdir $$PWD" --define "_tmppath /var/tmp" \
    $(OS.RPM_FLAGS) $(ARCH.RPM_FLAGS) \
    $(PROJECT.RPM_FLAGS) $(LOCAL.RPM_FLAGS) $(TARGET.RPM_FLAGS)

package:	package-rpm-repo
package-rpm-repo:	$(SPEC_SRC:%=package-rpm-repo[%])

package-rpm-repo[%]:
	$(RPMBUILD) -bb $(RPM_FLAGS) SPECS/$*

clean:  clean-rpm-repo
distclean:  clean-rpm-repo
clean-rpm-repo:
	rm -rf BUILD/* BUILDROOT/* RPMS/* SRPMS/*

#
# src-rpm-repo: --Find the spec files in the SPECS part of the repo.
#
src:	src-rpm-repo
src-rpm-repo:
	$(ECHO_TARGET)
	cd SPECS && mk-filelist -qn SPEC_SRC *.spec
