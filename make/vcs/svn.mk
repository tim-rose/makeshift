#
# SVN.MK --Build rules for working with "subversion" repositories.
#
#
# Contents:
# vcs-status-ok: --Test there are no unresolved changes in the repository.
# vcs-tag:       --Make a release tag in SVN.
#
VCS_EXCLUDES = --exclude .svn

#
# vcs-status-ok: --Test there are no unresolved changes in the repository.
#
.PHONY:		vcs-status-ok
vcs-status-ok:
	$(ECHO_TARGET)
	@n=$$(svn status -u |grep -v '^[X?]' | wc -l); \
	if [ $$n -gt 1 ]; then \
	    echo "There are $$(( $$n-1 )) unresolved changes"; \
	    false; \
	fi
#
# vcs-tag: --Make a release tag in SVN.
#
vcs-tag[%]:	vcs-status-ok
	$(ECHO_TARGET)
	@url=$$(svn info|sed -n -e '/^URL:/s/URL: //p'); \
	tag_url=$$(echo $$url | sed -e 's|trunk|tags/$*|'); \
	if ! svn info $$tag_url 2>&1 | grep -q 'Not a valid URL'; then \
	    echo "$$tag_url (already exists)"; \
	    false; \
	else \
	    echo "svn cp -m 'Release $*' $$url $$tag_url"; \
	    svn cp -m '$(PACKAGE) release $*' $$url $$tag_url; \
	fi
