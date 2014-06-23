#
# Makefile --Build rules for the make directory of devkit.
#
# Contents:
#
# Remarks:
# THe "toc" target cannot be run until things have been installed in DEV_HOME.
#
STD_TRG = install uninstall install-strip \
	clean distclean tags dist
DEVKIT_TRG = build src depend test toc tidy doc todo

MK_SRC = build.mk database.mk deb.mk deploy.mk devkit.mk library.mk \
    package.mk repository.mk tap.mk targets.mk valid.mk

include devkit.mk

$(includedir)/%:	%;		$(INSTALL_FILE) $< $@
install:		$(MK_SRC:%=$(includedir)/%)
install:		$(includedir)/targets.mk

clean:			clean-make
dist-clean:		clean-make
clean-make:		;		$(RM) targets.mk

#
# tarkets.mk:	--Build the standard auto-recursive targets file.
#
# Remarks:
# The auto-recursive rule pattern is a bit tedious to write by hand,
# so I've written a make target to generate them automatically.
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
	    printf "$$t@%%:\n\t@if [ -e \$$*/Makefile ]; then \$$(ECHO) ++ make: recursively building \$$@; cd \$$* && \$$(MAKE) $$t; fi\n"; \
	done >> $@
