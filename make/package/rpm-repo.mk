#
# rpm-repo.mk --Definitions for integrating an RPM repo into devkit.
#
package:	package-rpm-repo
package-rpm-repo:
	rpmbuild -bb --define "_topdir $$PWD" --define "_tmppath /var/tmp" SPECS/*.spec 

clean:  clean-rpm-repo
distclean:  clean-rpm-repo
clean-rpm-repo:
	rm -rf BUILD/* BUILDROOT/* RPMS/* SRPMS/*
