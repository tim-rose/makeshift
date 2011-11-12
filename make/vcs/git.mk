#
# GIT.MK --Build rules for working with "git" repositories
#
VCS_EXCLUDES = --exclude .git

#
# vcs-status-ok: --Test there are no unresolved changes in the repository.
#
.PHONY:		vcs-status-ok
vcs-status-ok:
	@export n=$$(git status -s | wc -l); \
	if [ $$n -gt 0 ]; then \
	    echo "There are $$n unresolved changes"; \
	    false; \
	fi
#
# vcs-tag: --Make a release tag in GIT.
#
vcs-tag[%]:	vcs-status-ok
	@$(ECHO) "++ make[$@]@$$PWD"
	git tag 'v$*' -m '$(PACKAGE) release $*' && git push

