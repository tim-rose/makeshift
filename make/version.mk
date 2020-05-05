#
# VERSION.MK --Rules for updating the project version.
#
# Contents:
# VERSION.mk:    --Include a make definition of the project version.
# distclean:     --Remove the (generated) version .mk
# major-version: --Increment the major version number.
# minor-version: --Increment the minor version number.
# patch-version: --Increment the patch version number.
# build-number:  --Increment the global build counter.
#
# Remarks:
# The project version is stored as a dotted triplet of numbers in the
# local file "VERSION".  The idea is to facilitate/encourage
# "semantic" versioning.  In any case, these rules provide mechanism
# only, not policy.
#
# In addition to the VERSION, a simple build identifier is stored in
# _BUILD.
#
# REVISIT: use git-describe (svn-describe) to set _BUILD.
#
.PHONY: clean-version major-version minor-version patch-version build-number

#
# VERSION.mk: --Include a make definition of the project version.
#
# Remarks:
# If the file does not exist it will be created by the following rule.
#
include ./_VERSION.mk

_VERSION.mk:	_VERSION _BUILD
	date "+# DO NOT EDIT.  File generated at %c by $$USER@$$HOSTNAME" >$@
	echo "export VERSION=$$(cat _VERSION)" >>$@
	echo "export BUILD=$$(cat _BUILD)" >>$@

#
# distclean: --Remove the (generated) version .mk
#
distclean: clean-version
clean-version:
	$(RM) ./_VERSION.mk

#
# major-version: --Increment the major version number.
#
# Remarks:
# A major version is used for significant architectural changes, and
# any backward incompatible changes.
#
_VERSION:; echo "0.0.0" >_VERSION
_BUILD:; echo "0" >_BUILD

major-version: _VERSION
	major=$$(<_VERSION cut -d. -f1); \
	minor=$$(<_VERSION cut -d. -f2); \
	patch=$$(<_VERSION cut -d. -f3); \
	echo "$$((major+1)).0.0" >_VERSION
	echo 0 >_BUILD

#
# minor-version: --Increment the minor version number.
#
# Remarks:
# A minor version is used for feature development, or any
# backward compatible changes.
#
minor-version: _VERSION
	major=$$(<_VERSION cut -d. -f1); \
	minor=$$(<_VERSION cut -d. -f2); \
	patch=$$(<_VERSION cut -d. -f3); \
	echo "$$major.$$((minor+1)).0" >_VERSION
	echo 0 >_BUILD

#
# patch-version: --Increment the patch version number.
#
# Remarks:
# Patch versions are used for bug fixes.
#
patch-version: _VERSION
	major=$$(<_VERSION cut -d. -f1); \
	minor=$$(<_VERSION cut -d. -f2); \
	patch=$$(<_VERSION cut -d. -f3); \
	echo "$$major.$$minor.$$((patch+1))" >_VERSION
	echo 0 >_BUILD

#
# build-number: --Increment the global build counter.
#
build-number: _BUILD
	build=$$(cat _BUILD) && echo $$((build+1)) >_BUILD
