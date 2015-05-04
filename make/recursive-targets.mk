#
# RECURSIVE-TARGETS.MK --Define devkit's recursive targets.
#
# Remarks:
# The recursive targets are invoked on all subdirectories that contain
# a Makefile, named either as "Makefile", as "Makefile-<arch>", for some
# value of ARCH.
#
std-targets = build install test uninstall install-strip \
	clean distclean tags dist doc coverage
devkit-targets = src toc tidy todo
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
            $$(ECHO) ++ make: recursively building $$@; \
            cd $$* >/dev/null && $$(MAKE) -f Makefile-$(OS) $1; \
	elif [ -e $$*/Makefile-$(ARCH) ]; then \
            $$(ECHO) ++ make: recursively building $$@; \
            cd $$* >/dev/null && $$(MAKE) -f Makefile-$(ARCH) $1; \
        elif [ -e $$*/Makefile ]; then \
            $$(ECHO) ++ make: recursively building $$@; \
            cd $$* >/dev/null && $$(MAKE) $1; \
        fi
endef

$(foreach target,$(recursive-targets),$(eval $(call recursive_rule,$(target))))
