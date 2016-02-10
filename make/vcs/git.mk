#
# GIT.MK --Build rules for working with "git" repositories
#
VCS_EXCLUDES = --exclude .git

#
# vcs-status-ok: --Test there are no unresolved changes in the repository.
#
.PHONY:		vcs-status-ok
vcs-status-ok:
	@$(ECHO_TARGET)
	@export n=$$(git status -s | wc -l); \
	if [ $$n -gt 0 ]; then \
	    echo "There are $$n unresolved changes"; \
	    false; \
	fi
#
# vcs-tag: --Make a release tag in GIT.
#
vcs-tag[%]:	vcs-status-ok
	@$(ECHO_TARGET)
	@if [ "$(git tag | grep "^v$*$$"|wc -l)" != "0" ]; then \
	    echo "release $* already exists"; false; \
	else \
	    echo "git tag 'v$*' -m '$(PACKAGE) release $*' && git push --tags"; \
	fi

