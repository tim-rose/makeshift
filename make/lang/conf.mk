#
# CONF.MK --Rules for building config files.
#
# Contents:
# %.conf:           --Pattern rules for installing config files.
# conf-src-defined: --Test if any of the "conf" SRC vars. are defined.
# install:          --Install config files to sysconfdir
# uninstall-conf:   --Uninstall the default config files.
# toc:              --Build the table-of-contents for config files.
# src:              --Update definitions of CONF_SRC, CFG_SRC, INI_SRC.
# todo:             --Report "unfinished work" comments in config files.
#
# Remarks:
# Config files can have a variety of extensions (".conf", ".ini",
# ".cfg").  The conf module supports all of these via the macros
# CONF_SRC, INI_SRC, CFG_SRC.  It defines rules for installing the
# config files into $(sysconfdir), and $(divertdir). FWIW, divertdir
# is useful on debian-based systems; it helps support local
# customisation of another package's config files.
#
.PHONY: $(recursive-targets:%=%-conf)

ifdef autosrc
    LOCAL_CONF_SRC := $(wildcard *.conf)
    LOCAL_CFG_SRC := $(wildcard *.cfg)
    LOCAL_INI_SRC := $(wildcard *.ini)

    CONF_SRC ?= $(LOCAL_CONF_SRC)
    CFG_SRC ?= $(LOCAL_CFG_SRC)
    INI_SRC ?= $(LOCAL_INI_SRC)
endif

#
# %.conf: --Pattern rules for installing config files.
#
$(system_confdir)/%:	%.conf;		$(INSTALL_DATA) $? $@
$(sysconfdir)/%:	%.conf;		$(INSTALL_DATA) $? $@
$(divertdir)/%:		%.conf;		$(INSTALL_DATA) $? $@

$(sysconfdir)/%.conf:	%.conf;		$(INSTALL_DATA) $? $@
$(sysconfdir)/%.cfg:	%.cfg;		$(INSTALL_DATA) $? $@
$(sysconfdir)/%.ini:	%.ini;		$(INSTALL_DATA) $? $@

$(divertdir)/%.conf:	%.conf;		$(INSTALL_DATA) $? $@
$(divertdir)/%.cfg:	%.cfg;		$(INSTALL_DATA) $? $@
$(divertdir)/%.ini:	%.ini;		$(INSTALL_DATA) $? $@

$(system_confdir)/%.conf:	%.conf;		$(INSTALL_DATA) $? $@
$(system_confdir)/%.cfg:	%.cfg;		$(INSTALL_DATA) $? $@
$(system_confdir)/%.ini:	%.ini;		$(INSTALL_DATA) $? $@

#
# conf-src-defined: --Test if any of the "conf" SRC vars. are defined.
#
conf-src-defined:
	@if [ ! '$(CONF_SRC)$(CFG_SRC)$(INI_SRC)' ]; then \
	    printf $(VAR_UNDEF) "CONF_SRC, CFG_SRC, INI_SRC"; \
	    echo 'run "make src" to define them'; \
	    false; \
	fi >&2

#
# install: --Install config files to sysconfdir.
#
install-conf:	$(CONF_SRC:%=$(sysconfdir)/%) \
    $(CFG_SRC:%=$(sysconfdir)/%) $(INI_SRC:%=$(sysconfdir)/%)
	$(ECHO_TARGET)
install-system_conf:	$(CONF_SRC:%=$(system_confdir)/%) \
    $(CFG_SRC:%=$(system_confdir)/%) $(INI_SRC:%=$(system_confdir)/%)
	$(ECHO_TARGET)

#
# uninstall: --Uninstall the default config files.
#
uninstall-conf:
	$(ECHO_TARGET)
	$(RM) $(CONF_SRC:%=$(sysconfdir)/%) \
            $(CFG_SRC:%=$(sysconfdir)/%) $(INI_SRC:%=$(sysconfdir)/%)
	$(RMDIR) -p $(sysconfdir) 2>/dev/null || true
uninstall-system_conf:
	$(ECHO_TARGET)
	$(RM) $(CONF_SRC:%=$(system_confdir)/%) \
            $(CFG_SRC:%=$(system_confdir)/%) $(INI_SRC:%=$(system_confdir)/%)
	$(RMDIR) -p $(system_confdir) 2>/dev/null || true

#
# toc: --Build the table-of-contents for config files.
#
toc:	toc-conf
toc-conf:	conf-src-defined
	$(ECHO_TARGET)
	mk-toc $(CONF_SRC) $(CFG_SRC) $(INI_SRC)

#
# src: --Update definitions of CONF_SRC, CFG_SRC, INI_SRC.
#
src:	src-conf
src-conf:
	$(ECHO_TARGET)
	@mk-filelist -qn CONF_SRC *.conf
	@mk-filelist -qn CFG_SRC *.cfg
	@mk-filelist -qn INI_SRC *.ini

#
# todo: --Report "unfinished work" comments in config files.
#
todo:	todo-conf
todo-conf:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(CONF_SRC) $(CFG_SRC) $(INI_SRC) /dev/null || true
