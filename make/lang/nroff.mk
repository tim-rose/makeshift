#
# NROFF.MK --Rules for building nroff files.
#
# Contents:
# toc-nroff:     --Build the table-of-contents for nroff files.
# src-nroff:     --specific-nroff customisations for the "src" target.
# install-man:   --install manual pages in their usual places.
# uninstall-man: --uninstall manual pages from their usual places.
# clean-nroff:   --Cleanup nroff files.
# todo:          --Report unfinished work (identified by keyword comments)
# +version:      --Report details of tools used by nroff.
#
.PHONY: $(recursive-targets:%=%-nroff)

export DATE ?= $(shell date '+%d %B %Y')

ifdef autosrc
    LOCAL_MAN1_SRC := $(wildcard *.1)
    LOCAL_MAN3_SRC := $(wildcard *.3)
    LOCAL_MAN5_SRC := $(wildcard *.5)
    LOCAL_MAN7_SRC := $(wildcard *.7)
    LOCAL_MAN8_SRC := $(wildcard *.8)

    MAN1_SRC ?= $(LOCAL_MAN1_SRC)
    MAN3_SRC ?= $(LOCAL_MAN3_SRC)
    MAN5_SRC ?= $(LOCAL_MAN5_SRC)
    MAN7_SRC ?= $(LOCAL_MAN7_SRC)
    MAN8_SRC ?= $(LOCAL_MAN8_SRC)
endif

NROFF_SET_VERSION = sed -e '/^[.]TH/s/\<PACKAGE>/$(PACKAGE)/;/^[.]TH/s/\<VERSION\>/$(VERSION)/;/^[.]TH/s/\<DATE\>/$(DATE)/'
#
# %.[1-9]:	--Rules for installing manual pages
#

$(man1dir)/%.1:	$(archdir)/%.1;	$(INSTALL_DATA) $? $@
$(man3dir)/%.3:	$(archdir)/%.3;	$(INSTALL_DATA) $? $@
$(man4dir)/%.4:	$(archdir)/%.4;	$(INSTALL_DATA) $? $@
$(man5dir)/%.5:	$(archdir)/%.5;	$(INSTALL_DATA) $? $@
$(man6dir)/%.6:	$(archdir)/%.6;	$(INSTALL_DATA) $? $@
$(man7dir)/%.7:	$(archdir)/%.7;	$(INSTALL_DATA) $? $@
$(man8dir)/%.8:	$(archdir)/%.8;	$(INSTALL_DATA) $? $@

%.1.pdf:	$(archdir)/%.1;	man -t $? | ps2pdf - - > $@
%.3.pdf:	$(archdir)/%.3;	man -t $? | ps2pdf - - > $@
%.4.pdf:	$(archdir)/%.3;	man -t $? | ps2pdf - - > $@
%.5.pdf:	$(archdir)/%.5;	man -t $? | ps2pdf - - > $@
%.6.pdf:	$(archdir)/%.6;	man -t $? | ps2pdf - - > $@
%.7.pdf:	$(archdir)/%.7;	man -t $? | ps2pdf - - > $@
%.8.pdf:	$(archdir)/%.8;	man -t $? | ps2pdf - - > $@

$(archdir)/%.1: %.1 | $(archdir); $(NROFF_SET_VERSION) <$? >$@
$(archdir)/%.3: %.3 | $(archdir); $(NROFF_SET_VERSION) <$? >$@
$(archdir)/%.4: %.4 | $(archdir); $(NROFF_SET_VERSION) <$? >$@
$(archdir)/%.5: %.5 | $(archdir); $(NROFF_SET_VERSION) <$? >$@
$(archdir)/%.6: %.6 | $(archdir); $(NROFF_SET_VERSION) <$? >$@
$(archdir)/%.7: %.7 | $(archdir); $(NROFF_SET_VERSION) <$? >$@
$(archdir)/%.8: %.8 | $(archdir); $(NROFF_SET_VERSION) <$? >$@

build:	build-nroff

build-nroff: $(MAN1_SRC:%=$(archdir)/%) $(MAN3_SRC:%=$(archdir)/%) \
	$(MAN4_SRC:%=$(archdir)/%) $(MAN5_SRC:%=$(archdir)/%) \
	$(MAN7_SRC:%=$(archdir)/%) $(MAN8_SRC:%=$(archdir)/%) | $(archdir)

#
# toc-nroff: --Build the table-of-contents for nroff files.
#
toc:	toc-nroff
toc-nroff:
	$(ECHO_TARGET)
	mk-toc $(MAN1_SRC) $(MAN3_SRC) $(MAN4_SRC) \
	    $(MAN5_SRC) $(MAN7_SRC) $(MAN8_SRC)

#
# src-nroff: --specific-nroff customisations for the "src" target.
#
# We only really care about some of the manual sections; specifically
# section 2 (system calls) and 4 (special files) are not something
# we're likely to write.
#
src:	src-nroff
src-nroff:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qn MAN1_SRC *.1
	$(Q)mk-filelist -f $(MAKEFILE) -qn MAN3_SRC *.3
	$(Q)mk-filelist -f $(MAKEFILE) -qn MAN5_SRC *.5
	$(Q)mk-filelist -f $(MAKEFILE) -qn MAN7_SRC *.7
	$(Q)mk-filelist -f $(MAKEFILE) -qn MAN8_SRC *.8

doc-pdf:	$(MAN1_SRC:%.1=%.1.pdf) $(MAN3_SRC:%.3=%.3.pdf) \
	$(MAN5_SRC:%.5=%.5.pdf) $(MAN7_SRC:%.7=%.7.pdf) \
	$(MAN8_SRC:%.8=%.8.pdf)

install:	install-man
uninstall:	uninstall-man

#
# install-man:  --install manual pages in their usual places.
#
# Remarks:
# Most documents aren't "installed" as such, but somewhat famously,
# Unix manual pages *are*.
#
.PHONY: install-man
install-man:    $(MAN1_SRC:%=$(man1dir)/%) $(MAN3_SRC:%=$(man3dir)/%) \
    $(MAN5_SRC:%=$(man5dir)/%) $(MAN7_SRC:%=$(man7dir)/%) \
    $(MAN8_SRC:%=$(man8dir)/%)

#
# uninstall-man:  --uninstall manual pages from their usual places.
#
.PHONY: uninstall-man
uninstall-man:
	$(RM) $(MAN1_SRC:%=$(man1dir)/%) $(MAN3_SRC:%=$(man3dir)/%) $(MAN5_SRC:%=$(man5dir)/%) $(MAN7_SRC:%=$(man7dir)/%) $(MAN8_SRC:%=$(man8dir)/%)
	$(RMDIR) $(man1dir) $(man3dir) $(man5dir) $(man7dir) $(man8dir)

#
# clean-nroff: --Cleanup nroff files.
#
distclean:	clean-nroff
clean:	clean-nroff
clean-nroff:
	$(RM) $(MAN1_SRC:%.1=%.1.pdf) $(MAN3_SRC:%.3=%.3.pdf) $(MAN5_SRC:%.5=%.5.pdf) $(MAN7_SRC:%.7=%.7.pdf) $(MAN8_SRC:%.8=%.8.pdf)

#
# todo: --Report unfinished work (identified by keyword comments)
#
todo:	todo-nroff
todo-nroff:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(MAN1_SRC) $(MAN3_SRC) $(MAN5_SRC) $(MAN7_SRC) $(MAN8_SRC) /dev/null ||:

#
# +version: --Report details of tools used by nroff.
#
+version: cmd-version[groff] cmd-version[ps2pdf]
