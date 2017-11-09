#
# CRON.MK --Rules for installing cron(8) files.
#
# Contents:
# src-cron: --Update the CRON_SRC macro.
#
.PHONY: $(recursive-targets:%=%-cron)

ifdef autosrc
    LOCAL_CRON_SRC := $(wildcard *.cron)

    CRON_SRC ?= $(LOCAL_CRON_SRC)
endif

#
# rules to install to the system cron fragments location.
#
$(sysconfdir)/cron.d/%:			%;	$(INSTALL_DATA) $? $@
$(system_confdir)/cron.d/%:		%;	$(INSTALL_DATA) $? $@

#
# rules to install to the system cron run-parts locations.
#
$(sysconfdir)/cron.hourly/%:		%;	$(INSTALL_SCRIPT) $? $@
$(sysconfdir)/cron.daily/%:		%;	$(INSTALL_SCRIPT) $? $@
$(sysconfdir)/cron.weekly/%:		%;	$(INSTALL_SCRIPT) $? $@
$(sysconfdir)/cron.monthly/%:		%;	$(INSTALL_SCRIPT) $? $@

$(system_confdir)/cron.hourly/%:	%;	$(INSTALL_SCRIPT) $? $@
$(system_confdir)/cron.daily/%:		%;	$(INSTALL_SCRIPT) $? $@
$(system_confdir)/cron.weekly/%:	%;	$(INSTALL_SCRIPT) $? $@
$(system_confdir)/cron.monthly/%:	%;	$(INSTALL_SCRIPT) $? $@

#
# src-cron: --Update the CRON_SRC macro.
#
src:	src-cron
src-cron:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn CRON_SRC *.cron
