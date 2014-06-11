#
# DEB.MK --Targets for building Debian packages.
#
# Contents:
# deb:            --Tests and dependencies for building a debian archive.
# debian-binary:  --Create the "debian-binary" file automatically.
# control.tar.gz: --Create the control tarball from the debian subdirectory.
# data.tar.gz:    --Create the installed binary tarball.
# .data:          --Construct the installed system in a special sub-directory.
# md5sums:        --Calculate the md5sums for all the installed files.
# conffiles:      --Make "conffiles" as required.
# control-ok:     --Test that the control file has the correct information.
# version-match:  --Compare debian/control version with intrinsic Makefile.
# perl-depend:    --Calculate perl dependencies.
# clean:          --Remove derived files created as a side-effect of packaging.
# distclean:      --Remove the package.
#
# Remarks:
# There are many ways to build a debian package, and this is
# just one more to add to the confusion.
#

#
# deb: --Tests and dependencies for building a debian archive.
#
# Remarks:
# because the tests are "phony", they must be associated with
# (i.e. dependents of) a phony target only, or we re-build stuff too
# often.
#
.PHONY:	deb
deb:	control-ok $(PVRA).deb

$(PVRA).deb:	debian-binary control.tar.gz data.tar.gz
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
data.tar.gz:	.data
	$(ECHO_TARGET)
	(cd .data; $(FAKEROOT) tar zcf ../$@ *)

#
# .data: --Construct the installed system in a special sub-directory.
#
# Remarks:
# This target runs make in a special way, but it needs to make
# sure that the system is already built in the "standard" way
# (i.e. build must be done before installdirs/install)
#
.data:	build
	$(MAKE) $(MFLAGS) installdirs install \
		 DESTDIR=$$(pwd)/.data prefix= usr=usr

#
# md5sums: --Calculate the md5sums for all the installed files.
#
debian/md5sums: .data
	$(ECHO_TARGET)
	find .data -type f | xargs md5sum | sed -e s@.data/@@ > $@
	chmod 644 $@

#
# conffiles: --Make "conffiles" as required.
#
# Remarks:
# This rule makes the file if it doesn't exist, but if it's
# subsequently modified it won't be trashed by this rule.
#
debian/conffiles: .data
	@touch $@
	@if [ -d .data/etc ]; then \
	    $(ECHO) '++make[$@]: automatically generated'; \
	    find .data/etc -type f | sed -e s@.data/@/@ > $@; \
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
#	@size=$$(du -sk  .data | cut -d '	' -f1);\
#	    grep >/dev/null '^Installed-Size: *$$size' debian/control ||\
#	    (echo "Error: Installed size is incorrect in debian/control"; false)

#
# version-match: --Compare debian/control version with intrinsic Makefile.
#
version-match[%]:
	$(ECHO_TARGET)
	@fgrep -q 'Version: $*' debian/control

#
# perl-depend: --Calculate perl dependencies.
#
# Remarks:
#
# This is is MUCH less useful than I had first thought, because
# "deb.mk" is only included in the top-level makefile, and so only
# finds dependencies on stuff in the current directory.  Either
# I need to abandon recursive makes, or include deb.mk, or come
# up with another, better solution.
#
perl-depend: .data
	dpkg -S $$(find .data -name grep ^use $(PM_SRC) $(PL_SRC) \
	    | sed -e 's/.*use \([a-zA-Z_0-9:]*\).*/\1/' \
	    | sort -u \
	    | egrep -v 'warnings|strict|base|integer' \
	    | sed -e 's@::@/@g' -e 's/$$/.pm/') 2>/dev/null \
	| sed -e 's/:.*//' \
	| sort -u \
	| egrep -v '^perl|perl-base$$'

#
# clean: --Remove derived files created as a side-effect of packaging.
#
clean:	deb-clean
deb-clean:
	$(ECHO_TARGET)
	$(RM) -r .data
	$(RM) debian-binary control.tar.gz data.tar.gz

#
# distclean: --Remove the package.
#
distclean:	deb-clean deb-distclean
deb-distclean:
	$(ECHO_TARGET)
	$(RM) debian/conffiles debian/md5sums $(PVRA).deb
