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
#
.PHONY: $(recursive-targets:%=%-nroff)

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

#
# %.[1-9]:	--Rules for installing manual pages
#
# TODO: finish implementing patterns for all sections

$(man1dir)/%.1:	%.1;	$(INSTALL_DATA) $? $@
$(man2dir)/%.2:	%.2;	$(INSTALL_DATA) $? $@
$(man3dir)/%.3:	%.3;	$(INSTALL_DATA) $? $@
$(man4dir)/%.4:	%.4;	$(INSTALL_DATA) $? $@
$(man5dir)/%.5:	%.5;	$(INSTALL_DATA) $? $@
$(man6dir)/%.6:	%.6;	$(INSTALL_DATA) $? $@
$(man7dir)/%.7:	%.7;	$(INSTALL_DATA) $? $@
$(man8dir)/%.8:	%.8;	$(INSTALL_DATA) $? $@

%.1.pdf:	%.1;	man -t ./$*.1 | ps2pdf - - > $@
%.3.pdf:	%.3;	man -t ./$*.3 | ps2pdf - - > $@
%.5.pdf:	%.5;	man -t ./$*.5 | ps2pdf - - > $@
%.7.pdf:	%.7;	man -t ./$*.7 | ps2pdf - - > $@
%.8.pdf:	%.8;	man -t ./$*.8 | ps2pdf - - > $@

#
# toc-nroff: --Build the table-of-contents for nroff files.
#
toc:	toc-nroff
toc-nroff:
	@$(ECHO_TARGET)
	mk-toc $(MAN1_SRC) $(MAN3_SRC) $(MAN5_SRC) $(MAN7_SRC) $(MAN8_SRC)

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
	@mk-filelist -f $(MAKEFILE) -qn MAN1_SRC *.1
	@mk-filelist -f $(MAKEFILE) -qn MAN3_SRC *.3
	@mk-filelist -f $(MAKEFILE) -qn MAN5_SRC *.5
	@mk-filelist -f $(MAKEFILE) -qn MAN7_SRC *.7
	@mk-filelist -f $(MAKEFILE) -qn MAN8_SRC *.8

doc:	$(MAN1_SRC:%.1=%.1.pdf) $(MAN3_SRC:%.3=%.3.pdf) \
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
	$(RMDIR) -p $(man1dir) $(man3dir) $(man5dir) $(man7dir) $(man8dir) 2>/dev/null ||:

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
