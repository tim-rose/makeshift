#
# Makefile --Build rules for the make directory of devkit.
#
# Contents:
#
# Remarks:
# The "toc" target cannot be run until things have been installed in DEV_HOME.
#
STD_TRG = build install test uninstall install-strip \
	clean distclean tags dist doc coverage
DEVKIT_TRG = src toc tidy todo

MK_SRC = coverage.mk deb.mk deploy.mk devkit.mk doxygen.mk ld.mk \
    library.mk package.mk repository.mk valid.mk

include devkit.mk

$(includedir)/%:	%;		$(INSTALL_FILE) $< $@
install:		$(MK_SRC:%.mk=$(includedir)/%.mk)
install:		$(includedir)/targets.mk

mk-src: rm-targets.mk
rm-targets.mk:		;		@$(RM) targets.mk
#
# tarkets.mk:	--Build the standard auto-recursive targets file.
#
# Remarks:
# The auto-recursive rule pattern is a bit tedious to write by hand,
# so I've written a make target to generate them automatically. Even so,
# it's incredibly dense; it might be better as a separate script?
#
targets.mk:
	@$(ECHO) "++ make[$@]"
	@printf "#\n# $@ --auto-recursive targets, generated %s\n#\n" "$$(date '+%c')" > $@
	@for t in $(STD_TRG) $(DEVKIT_TRG); do \
	    printf "\n#\n# $$t: --auto-recursive target\n#\n"; \
	    printf ".PHONY:\t$$t pre-$$t\n"; \
	    printf "$$t:\t\$$(SUBDIRS:%%=$$t@%%); \$$(ECHO_TARGET)\n"; \
	    printf "pre-$$t:\t;\t\$$(ECHO_TARGET)\n"; \
	    printf "$$t \$$(SUBDIRS:%%=$$t@%%):\tpre-$$t\n"; \
	    printf "$$t@%%:\n\t@\$$(ECHO_TARGET)\n\t@if [ -e \$$*/Makefile ]; then \$$(ECHO) ++ make: recursively building \$$@; cd \$$* >/dev/null && \$$(MAKE) $$t; fi\n"; \
	done >> $@
