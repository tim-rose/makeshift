#
# RECURSIVE-TARGETS.MK --Define devkit's recursive targets.
#
std-targets = build install test uninstall install-strip \
	clean distclean tags dist doc coverage
devkit-targets = src toc tidy todo
recursive-targets = $(std-targets) $(devkit-targets)

+var[recursive_rule]:;# disable +var[%]
define recursive_rule
.PHONY:	$1 pre-$1
$1:	$$(SUBDIRS:%=$1@%);	$$(ECHO_TARGET)
pre-$1:	;			$$(ECHO_TARGET)
$1 $(SUBDIRS:%=$1@%):	pre-$1
$1@%:
	@$$(ECHO_TARGET)
	@if [ -e $$*/Makefile ]; then \
            $$(ECHO) ++ make: recursively building $$@; \
            cd $$* >/dev/null && $$(MAKE) $1; \
        fi
endef

$(foreach target,$(recursive-targets),$(eval $(call recursive_rule,$(target))))
