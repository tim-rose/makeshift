#
# RECURSIVE-TARGETS.MK --Define devkit's recursive targets.
#
# Remarks:
# The recursive targets are invoked on all subdirectories that contain
# a Makefile matching the following patterns in order:
#
#  * Makefile-<OS> --OS-specific make rules (e.g. Makefile-linux)
#  * Makefile-<ARCH> --architecture-specific make rules
#  * Makefile --a "normal" make file.
#
# Note that if *any* of these files exist, the recursion will occur,
# using the first Makefile that matches.  So, it is possible to create
# sub-directories that are only processed for particular OS or ARCH,
# or that have customised behaviour for OS, ARCH.
#
# The recursive targets and their meaning are documented in the GNU
# make manual.
#
# For every recursive target, there are two special targets:
# * pre-*target* --actions to perform *before* recursing into sub-directories
# * post-*target* --actions to perform *after* recursing into sub-directories
#
# These targets can be used to control when particular actions are run.
#
# See Also:
# http://www.gnu.org/software/make/manual/make.html#Standard-Targets
#
std-targets = build install test uninstall \
	clean distclean tags dist doc coverage
devkit-targets = src toc lint tidy todo
recursive-targets = $(std-targets) $(devkit-targets)

#
# install-strip: --install stuff, and strip binaries.
#
# Remarks:
# Because there can't really be multiple rules for building the same
# file, install-strip is achieved by re-invoking the same makefile,
# with an altered definition of INSTALL_PROGRAM.  Note that the "-f"
# option is not automatically passed to the child make, so we must do
# it explicitly.
#
install-strip:;	$(MAKE) -f $(firstword $(MAKEFILE_LIST)) INSTALL_PROGRAM='$(INSTALL_PROGRAM) -s' install

+var[recursive_rule]:;@: # disable +var[recursive_rule]

#
# recursive_rule: --Define a set of targets that implement recursion.
#
# Parameters:
# $1 --the name of the recursive target
# $2 --flag: define the action for the recursive target.
#
define recursive_rule
.PHONY:	$1 pre-$1 post-$1 $1-subdirs
ifeq "$2" "1"
$1:	$$(SUBDIRS:%=$1@%) post-$1;	$$(ECHO_TARGET)
else
$1:	$$(SUBDIRS:%=$1@%) post-$1
endif
$1 $(SUBDIRS:%=$1@%):	pre-$1
$1-subdirs: $(SUBDIRS:%=$1@%)
post-$1: $(SUBDIRS:%=$1@%)
$1@%:
	@$$(ECHO_TARGET)
	@if [ -e $$*/Makefile-$(OS) ]; then \
            $$(ECHO) ++ make: recursively building $$@ for $(OS); \
            $$(MAKE) --directory $$* -f Makefile-$(OS) $1; \
        elif [ -e $$*/Makefile-$(ARCH) ]; then \
            $$(ECHO) ++ make: recursively building $$@ for $(ARCH); \
            $$(MAKE) --directory $$* -f Makefile-$(ARCH) $1; \
        elif [ -e $$*/Makefile ]; then \
            $$(ECHO) ++ make: recursively building $$@; \
            $$(MAKE) --directory $$* $1; \
	else (cd $$*); fi
endef

$(foreach target,$(recursive-targets),$(eval $(call recursive_rule,$(target),1)))
