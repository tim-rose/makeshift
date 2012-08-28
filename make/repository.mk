#
# REPOSITORY.MK --Rules for managing a debian repository
#
# Contents:
# trim:       --Remove all but the last REPO_KEEP versions of a package.
# repo-clean: --repo-specific customisations for the "src" target.
#
# Remarks:
# There is SURELY a better way of managing repositories than
# via a makefile like this, but, well I haven't got around to
# thinking one up yet
#
SORT_PKG_VERSION=sort -rn -t. -k 2,2 -k 3,3 -k 4,4
REPO_KEEP = 4
REPO_PKGS := $(shell ls *.deb | cut -d_ -f1 | uniq)

#
# trim: --Remove all but the last REPO_KEEP versions of a package.
#
.PHONY:	trim
trim:	$(REPO_PKGS:%=trim[%])
$(REPO_PKGS%=trim[%]):	pre-trim
pre-trim:	;
trim[%]:
	$(ECHO_TARGET)
	@files=$$(ls $*_* | \
	    sed -e s/_/./g | $(SORT_PKG_VERSION) | \
	    sed -e '1,$(REPO_KEEP)d' -e 's/[.]/_/' \
	        -e 's/[.]\([^.]*[.]deb\)/_\1/'); \
	for file in $$files; do \
	    $(ECHO) "removing old package $$file"; \
	    $(RM) $$file; \
	done;

build:	trim Packages.gz Contents.gz

#
# repo-clean: --repo-specific customisations for the "src" target.
#
clean:	repo-clean
.PHONY:	repo-clean
repo-clean:	
	$(ECHO_TARGET)
	$(RM) Packages* Contents*

Contents:	;	apt-ftparchive contents . > $@
Packages:	;	apt-ftparchive packages . > $@
Sources:	;	apt-ftparchive sources . > $@
Release:
	apt-ftparchive --config-file=./apt-ftparchive.conf release . > $@
