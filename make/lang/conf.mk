#
# CONF.MK --Rules for building config files.
#
# Contents:
# %.conf:              --Rules for installing config files.
# pre-build:           --Make sure that config SRC macros are defined.
# conf-src-var-defined: --Test if any of the conf SRC vars. are defined.
# toc-conf:            --Build the table-of-contents for config files.
# src-conf:            --Update definitions of CONF_SRC, CFG_SRC, INI_SRC
# todo:                --Report "unfinished work" comments in config files.
#

#
# %.conf: --Rules for installing config files.
#
$(sysconfdir)/%:	%.conf;		$(INSTALL_FILE) $? $@
$(divertdir)/%:		%.conf;		$(INSTALL_FILE) $? $@

$(sysconfdir)/%.conf:	%.conf;		$(INSTALL_FILE) $? $@
$(sysconfdir)/%.cfg:	%.cfg;		$(INSTALL_FILE) $? $@
$(sysconfdir)/%.ini:	%.ini;		$(INSTALL_FILE) $? $@

$(divertdir)/%.conf:	%.conf;		$(INSTALL_FILE) $? $@
$(divertdir)/%.cfg:	%.cfg;		$(INSTALL_FILE) $? $@
$(divertdir)/%.ini:	%.ini;		$(INSTALL_FILE) $? $@

#
# pre-build: --Make sure that config SRC macros are defined.
#
pre-build:	conf-src-var-defined

#
# conf-src-var-defined: --Test if any of the conf SRC vars. are defined.
#
conf-src-var-defined:
	@if [ -z '$(CONF_SRC)$(CFG_SRC)$(INI_SRC)' ]; then \
	    printf $(VAR_UNDEF) "CONF_SRC, CFG_SRC, INI_SRC"; \
	    echo 'run "make src" to define them'; \
	    false; \
	fi >&2
#
# toc-conf: --Build the table-of-contents for config files.
#
.PHONY: toc-conf
toc:	toc-conf
toc-conf:
	$(ECHO_TARGET)
	mk-toc $(CONF_SRC) $(CFG_SRC) $(INI_SRC)

#
# src-conf: --Update definitions of CONF_SRC, CFG_SRC, INI_SRC
#
src:	src-conf
.PHONY:	src-conf
src-conf:
	$(ECHO_TARGET)
	@mk-filelist -qn CONF_SRC *.conf
	@mk-filelist -qn CFG_SRC *.cfg
	@mk-filelist -qn INI_SRC *.ini

#
# todo: --Report "unfinished work" comments in config files.
#
.PHONY: todo-conf
todo:	todo-conf
todo-conf:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(CONF_SRC) $(CFG_SRC) $(INI_SRC) /dev/null || true
