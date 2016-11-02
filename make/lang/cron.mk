#
# CRON.MK --Rules for installing cron(8) files.
#
# Contents:
# src-cron: --Update the CRON_SRC macro.
#
.PHONY: $(recursive-targets:%=%-cron)

$(system_confdir)/cron.d/%.cron:	%.cron;	$(INSTALL_FILE) $? $@

#
# rules to install to the system cron run-parts locations.
#
$(system_confdir)/cron.hourly/%:	%;	$(INSTALL_PROGRAM) $? $@
$(system_confdir)/cron.daily/%:		%;	$(INSTALL_PROGRAM) $? $@
$(system_confdir)/cron.weekly/%:	%;	$(INSTALL_PROGRAM) $? $@
$(system_confdir)/cron.monthly/%:	%;	$(INSTALL_PROGRAM) $? $@

#
# src-cron: --Update the CRON_SRC macro.
#
src:	src-cron
src-cron:
	$(ECHO_TARGET)
	@mk-filelist -qn CRON_SRC *.cron
