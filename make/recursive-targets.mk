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
# using the first Makefile that matches.  So, it is possible to
# create sub-directories that are only processed for particular
# OS or ARCH, or that have customised behaviour for OS, ARCH.
#
# The recursive targets and their meaning are documented
# in the GNU make manual.
#
# See Also:
# http://www.gnu.org/software/make/manual/make.html#Standard-Targets
#
std-targets = build install test uninstall install-strip \
	clean distclean tags dist doc coverage
devkit-targets = src toc lint tidy todo
recursive-targets = $(std-targets) $(devkit-targets)

+var[recursive_rule]:;@: # disable +var[recursive_rule]

define recursive_rule
.PHONY:	$1 pre-$1
$1:	$$(SUBDIRS:%=$1@%);	$$(ECHO_TARGET)
pre-$1:	;			$$(ECHO_TARGET)
$1 $(SUBDIRS:%=$1@%):	pre-$1
$1@%:
	@$$(ECHO_TARGET)
	@if [ -e $$*/Makefile-$(OS) ]; then \
            $$(ECHO) ++ make: recursively building $$@ for $(OS); \
            cd $$* >/dev/null && $$(MAKE) -f Makefile-$(OS) $1; \
	elif [ -e $$*/Makefile-$(ARCH) ]; then \
            $$(ECHO) ++ make: recursively building $$@ for $(ARCH); \
            cd $$* >/dev/null && $$(MAKE) -f Makefile-$(ARCH) $1; \
        elif [ -e $$*/Makefile ]; then \
            $$(ECHO) ++ make: recursively building $$@; \
            cd $$* >/dev/null && $$(MAKE) $1; \
        fi
endef

$(foreach target,$(recursive-targets),$(eval $(call recursive_rule,$(target))))
