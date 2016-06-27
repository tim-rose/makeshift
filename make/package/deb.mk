#
# DEB.MK --Targets for building Debian packages.
#
# Contents:
# deb:            --Build a debian package for the current version/release/arch.
# debian-binary:  --Create the "debian-binary" file automatically.
# control.tar.gz: --Create the control tarball from the debian subdirectory.
# data.tar.gz:    --Create the installed binary tarball.
# md5sums:        --Calculate the md5sums for all the installed files.
# conffiles:      --Make "conffiles" as required.
# control-ok:     --Test that the control file has the correct information.
# deb-version-ok: --Compare debian/control's version with Makefile definitions.
# clean:          --Remove derived files created as a side-effect of packaging.
# distclean:      --Remove the package.
#
# Remarks:
# There are many ways to build a debian package, and this is
# just one more to add to the confusion.
#
DEB_ARCH ?= $(shell mk-deb-buildarch debian/control)
P_V.R	= $(PACKAGE)_$(VERSION).$(RELEASE)
V.R_A	= $(VERSION).$(RELEASE)_$(DEB_ARCH)
P_V.R_A	= $(PACKAGE)_$(VERSION).$(RELEASE)_$(DEB_ARCH)

#
# deb: --Build a debian package for the current version/release/arch.
#
# Remarks:
# "package-deb" and "deb" are aliases, for convenience.
#
.PHONY:		package-deb deb
package-deb:	deb
deb:	control-ok $(P_V.R_A).deb

$(P_V.R_A).deb:	debian-binary control.tar.gz data.tar.gz
	$(ECHO_TARGET)
	$(FAKEROOT) mk-ar debian-binary control.tar.gz data.tar.gz >$@

#
# debian-binary: --Create the "debian-binary" file automatically.
#
debian-binary:	;	echo "2.0" > $@

#
# control.tar.gz: --Create the control tarball from the debian subdirectory.
#
control.tar.gz:	debian/md5sums debian/conffiles
	$(ECHO_TARGET)
	(cd debian; \
	    test -f Makefile && $(MAKE) $(MFLAGS) all; \
	    $(FAKEROOT) tar zcf ../$@ --exclude 'Makefile' --exclude '*.*' *)

#
# data.tar.gz: --Create the installed binary tarball.
#
# Remarks:
# This target creates the ".data" sub-directory as a side-effect,
# which is also used by the md5sums target.  ".data" is removed
# by the clean target.
#
data.tar.gz:	$(DESTDIR_ROOT)
	$(ECHO_TARGET)
	(cd $(DESTDIR_ROOT); $(FAKEROOT) tar zcf ../$@ *)

#
# md5sums: --Calculate the md5sums for all the installed files.
#
debian/md5sums: $(DESTDIR_ROOT)
	$(ECHO_TARGET)
	find $(DESTDIR_ROOT) -type f | xargs md5sum | sed -e s@$(DESTDIR_ROOT)/@@ > $@
	chmod 644 $@

#
# conffiles: --Make "conffiles" as required.
#
# Remarks:
# This rule makes the file if it doesn't exist, but if it's
# subsequently modified it won't be trashed by this rule.
#
debian/conffiles: $(DESTDIR_ROOT)
	$(ECHO_TARGET)
	@touch $@
	@if [ -d $(DESTDIR_ROOT)/etc ]; then \
	    $(ECHO) '++make[$@]: automatically generated'; \
	    find $(DESTDIR_ROOT)/etc -type f | sed -e s@$(DESTDIR_ROOT)/@/@ > $@; \
	    chmod 644 $@; \
	fi

#
# control-ok: --Test that the control file has the correct information.
#
.PHONY:	control-ok
control-ok:	debian/control
	@grep >/dev/null '^Package: *$(PACKAGE)$$' debian/control ||\
	    (echo "Error: Package is incorrect in debian/control"; false)
	@grep >/dev/null '^Version: *$(VERSION).$(RELEASE)$$' debian/control ||\
	    (echo "Error: Version is incorrect in debian/control"; false)
#	@size=$$(du -sk  $(DESTDIR_ROOT) | cut -d '	' -f1);\
#	    grep >/dev/null '^Installed-Size: *$$size' debian/control ||\
#	    (echo "Error: Installed size is incorrect in debian/control"; false)

#
# deb-version-ok: --Compare debian/control's version with Makefile definitions.
#
release:	deb-version-ok[$(VERSION).$(RELEASE)]
deb-version-ok[%]:
	$(ECHO_TARGET)
	@fgrep -q 'Version: $*' debian/control

#
# clean: --Remove derived files created as a side-effect of packaging.
#
clean:	clean-deb
distclean:	clean-deb distclean-deb

.PHONY: clean-deb
clean-deb:
	$(ECHO_TARGET)
	$(RM) debian-binary control.tar.gz data.tar.gz

#
# distclean: --Remove the package.
#
.PHONY: distclean-deb
distclean-deb:
	$(ECHO_TARGET)
	$(RM) debian/conffiles debian/md5sums $(P_V.R_A).deb
