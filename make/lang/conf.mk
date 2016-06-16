#
# CONF.MK --Rules for building config files.
#
# Contents:
# %.conf:           --Pattern rules for installing config files.
# conf-src-defined: --Test if any of the "conf" SRC vars. are defined.
# install:          --Install config files to sysconfdir
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

ifdef AUTOSRC
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
$(sysconfdir)/%:	%.conf;		$(INSTALL_FILE) $? $@
$(divertdir)/%:		%.conf;		$(INSTALL_FILE) $? $@

$(sysconfdir)/%.conf:	%.conf;		$(INSTALL_FILE) $? $@
$(sysconfdir)/%.cfg:	%.cfg;		$(INSTALL_FILE) $? $@
$(sysconfdir)/%.ini:	%.ini;		$(INSTALL_FILE) $? $@

$(divertdir)/%.conf:	%.conf;		$(INSTALL_FILE) $? $@
$(divertdir)/%.cfg:	%.cfg;		$(INSTALL_FILE) $? $@
$(divertdir)/%.ini:	%.ini;		$(INSTALL_FILE) $? $@

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
# install: --Install config files to sysconfdir
#
install-conf:	$(CONF_SRC:%=$(sysconfdir)/%) \
    $(CFG_SRC:%=$(sysconfdir)/%) $(INI_SRC:%=$(sysconfdir)/%)
	$(ECHO_TARGET)

#
# uninstall-conf: --Uninstall the default config files.
#
uninstall-conf:
	$(ECHO_TARGET)
	$(RM) $(CONF_SRC:%=$(sysconfdir)/%) \
            $(CFG_SRC:%=$(sysconfdir)/%) $(INI_SRC:%=$(sysconfdir)/%)
	$(RMDIR) -p $(sysconfdir) 2>/dev/null || true

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
