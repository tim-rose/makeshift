#
# RECURSIVE-TARGETS.MK --Define makeshift's recursive targets.
#
# Contents:
# std-targets:    --The GNU standard targets, as described in the GNU make manual.
# makeshift-targets: --Extra development/maintenance targets.
# install-strip:  --install stuff, and strip binaries.
# recursive_rule: --Define a set of targets that implement recursion.
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
# For every recursive target, there are two special targets:
# * pre-*target* --actions to perform *before* recursing into sub-directories
# * post-*target* --actions to perform *after* recursing into sub-directories
#
# These targets can be used to control when particular actions are run.
#
# See Also:
# http://www.gnu.org/software/make/manual/make.html#Standard-Targets
#
# std-targets: --The GNU standard targets, as described in the GNU make manual.
#
# * clean --Delete files created by the build process.
# * distclean --Delete all non-source files, directories (i.e. ready for "dist")
# * build --Build all the things!
# * test --Run all the tests!
# * coverage --Build a coverage report based on the previous test run
# * install --Install everything to the local machine
# * uninstall --Remove everything that install created
# * package --Create an installable package (e.g. .deb, .rpm, etc.)
# * deploy --Install to a remote(?) machine, and restart etc. as needed
# * tags --Create IDE/navigation assistance files
# * dist --Create a distrubution package of the source files.
# * doc --Create/format the documentation
#
std-targets = clean distclean build test coverage \
    install uninstall \
    package deploy \
    tags dist doc
#
# makeshift-targets: --Extra development/maintenance targets.
#
# Remarks:
# These targets aren't part of GNU's preferred set, but (I) find
# them useful:
#
# * src --Update the Makefile with "SRC" definitions for each language-type.
# * toc --Update the table-of-contents of all source files.
# * lint --Run a static analyser over all source files.
# * tidy --Reformat all source files in a consistent style.
# * todo --Find and print all "todo", "revisit" and "fixme" annotations.
#
makeshift-targets = src toc lint tidy todo
recursive-targets = $(std-targets) $(makeshift-targets)

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
install-strip:
	$(MAKE) -f $(firstword $(MAKEFILE_LIST)) INSTALL_PROGRAM='$(INSTALL_PROGRAM) -s' install

+var[recursive_rule]:;@: # disable +var[recursive_rule]

#
# recursive_rule: --Define a set of targets that implement recursion.
#
# Parameters:
# $1 --the name of the recursive target
#
# Remarks:
# This macro creates a set of targets that allow some control over the
# recursion:
# * pre-<target>	--things to be done before running <target>
# * post-<target>	--things to be done after running the recursive targets
# * <target>@%		--a pattern rule for running <target> in a sub-directory
#
# Note that the target@dir rule will fail if the directory doesn't
# exist, so (e.g.)  `make build@bogus` will return an error, not
# silently do nothing.  This can arise from stale dependency
# declarations to directories that no longer exist.
#
define recursive_rule
.PHONY:	$1 pre-$1 post-$1 $1-subdirs

$1: 		pre-$1 $1-subdirs;     	$$(ECHO_TARGET)
$1-subdirs: 	$(SUBDIRS:%=$1@%);	$$(ECHO_TARGET)
post-$1:	$1-subdirs;		$$(ECHO_TARGET)

$1@%:	pre-$1
	@$$(ECHO_TARGET)
	@if [ -e $$*/Makefile-$(OS) ]; then \
            $$(ECHO) recursively building $$@ for $(OS); \
            $$(MAKE) --directory $$* -f Makefile-$(OS) $1; \
        elif [ -e $$*/Makefile-$(ARCH) ]; then \
            $$(ECHO) recursively building $$@ for $(ARCH); \
            $$(MAKE) --directory $$* -f Makefile-$(ARCH) $1; \
        elif [ -e $$*/Makefile ]; then \
            $$(ECHO) recursively building $$@; \
            $$(MAKE) --directory $$* $1; \
	else \
            $$(ECHO) no Makefile in $$@; \
            cd $$*; \
	fi
endef

#
# define all the standard recursive targets...
#
$(foreach target,$(recursive-targets),$(eval $(call recursive_rule,$(target))))
