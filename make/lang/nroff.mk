#
# NROFF.MK --Rules for building nroff files.
#
# Contents:
# nroff-toc:   --Build the table-of-contents for nroff files.
# nroff-src:   --nroff-specific customisations for the "src" target.
# nroff-clean: --Cleanup nroff files.
# todo:        --Report unfinished work (identified by keyword comments)
#

#
# %.[1-9]:	--Rules for installing manual pages
#
# TODO: finish implementing patterns for all sections

$(man1dir)/%.1:	%.1;	$(INSTALL_FILE) $? $@
$(man2dir)/%.2:	%.2;	$(INSTALL_FILE) $? $@
$(man3dir)/%.3:	%.3;	$(INSTALL_FILE) $? $@
$(man4dir)/%.4:	%.4;	$(INSTALL_FILE) $? $@
$(man5dir)/%.5:	%.5;	$(INSTALL_FILE) $? $@
$(man6dir)/%.6:	%.6;	$(INSTALL_FILE) $? $@
$(man7dir)/%.7:	%.7;	$(INSTALL_FILE) $? $@
$(man8dir)/%.8:	%.8;	$(INSTALL_FILE) $? $@

%.1.pdf:	%.1;	man -t ./$*.1 | ps2pdf - - > $@
%.3.pdf:	%.3;	man -t ./$*.3 | ps2pdf - - > $@
%.5.pdf:	%.5;	man -t ./$*.5 | ps2pdf - - > $@
%.7.pdf:	%.7;	man -t ./$*.7 | ps2pdf - - > $@
%.8.pdf:	%.8;	man -t ./$*.8 | ps2pdf - - > $@

#
# nroff-toc: --Build the table-of-contents for nroff files.
#
.PHONY: nroff-toc
toc:	nroff-toc
nroff-toc:
	@$(ECHO_TARGET)
	mk-toc $(MAN1_SRC) $(MAN3_SRC) $(MAN5_SRC) $(MAN7_SRC) $(MAN8_SRC)

#
# nroff-src: --nroff-specific customisations for the "src" target.
#
# We only really care about some of the manual sections; specifically
# section 2 (system calls) and 4 (special files) are not something
# we're likely to write.
#
src:	nroff-src
.PHONY:	nroff-src
nroff-src:	
	$(ECHO_TARGET)
	@mk-filelist -qn MAN1_SRC *.1
	@mk-filelist -qn MAN3_SRC *.3
	@mk-filelist -qn MAN5_SRC *.5
	@mk-filelist -qn MAN7_SRC *.7
	@mk-filelist -qn MAN8_SRC *.8

doc:	$(MAN1_SRC:%.1=%.1.pdf) \
	$(MAN3_SRC:%.3=%.3.pdf) \
	$(MAN5_SRC:%.5=%.5.pdf) \
	$(MAN7_SRC:%.7=%.7.pdf) \
	$(MAN8_SRC:%.8=%.8.pdf)

#
# nroff-clean: --Cleanup nroff files.
#
.PHONY: nroff-clean
distclean:	nroff-clean
clean:	nroff-clean
nroff-clean:
	$(RM) $(MAN1_SRC:%.1=%.1.pdf) $(MAN3_SRC:%.3=%.3.pdf) $(MAN5_SRC:%.5=%.5.pdf) $(MAN7_SRC:%.7=%.7.pdf) $(MAN8_SRC:%.8=%.8.pdf)

#
# todo: --Report unfinished work (identified by keyword comments)
#
.PHONY: nroff-todo
todo:	nroff-todo
nroff-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(MAN1_SRC) $(MAN3_SRC) $(MAN5_SRC) $(MAN7_SRC) $(MAN8_SRC) /dev/null || true
