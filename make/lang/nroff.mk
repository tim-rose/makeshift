#
# NROFF.MK --Rules for building nroff files.
#
# Contents:
# nroff-toc()   --Build the table-of-contents for nroff files.
# nroff-src()   --nroff-specific customisations for the "src" target.
# nroff-clean() --Cleanup nroff files.
# todo()        --Report unfinished work (identified by keyword comments)
# nroff-toc:    --Build the table-of-contents for nroff files.
# nroff-src:    --nroff-specific customisations for the "src" target.
# nroff-clean:  --Cleanup nroff files.
# todo:         --Report unfinished work (identified by keyword comments)
# %.[1-9]()     --Rules for installing manual pages
# nroff-toc()   --Build the table-of-contents for nroff files.
# nroff-src()   --nroff-specific customisations for the "src" target.
# nroff-clean() --Cleanup nroff files.
# todo()        --Report unfinished work (identified by keyword comments)
#

#
# %.[1-9]:	--Rules for installing manual pages
#

$(man1dir)/%.1:	%.1;	$(INSTALL_DATA) $? $@
$(man3dir)/%.3:	%.3;	$(INSTALL_DATA) $? $@
$(man4dir)/%.4:	%.4;	$(INSTALL_DATA) $? $@

%-1.pdf:	%.1;	man -t ./$*.1 | ps2pdf - - > $@
%-3.pdf:	%.3;	man -t ./$*.3 | ps2pdf - - > $@
%-4.pdf:	%.4;	man -t ./$*.4 | ps2pdf - - > $@

#
# nroff-toc: --Build the table-of-contents for nroff files.
#
.PHONY: nroff-toc
toc:	nroff-toc
nroff-toc:
	@$(ECHO) "++ make[$@]: rebuilding table-of-contents"
	mk-toc $(MAN1_SRC) $(MAN3_SRC) $(MAN4_SRC)

#
# nroff-src: --nroff-specific customisations for the "src" target.
#
src:	nroff-src
.PHONY:	nroff-src
nroff-src:	
	@$(ECHO) "++ make[$@]@$$PWD"
	@mk-filelist -qn MAN1_SRC *.1
	@mk-filelist -qn MAN3_SRC *.3
	@mk-filelist -qn MAN4_SRC *.4

doc:	$(MAN1_SRC:%.1=%-1.pdf) $(MAN3_SRC:%.3=%-3.pdf) $(MAN4_SRC:%.4=%-4.pdf)


#
# nroff-clean: --Cleanup nroff files.
#
.PHONY: nroff-clean
distclean:	nroff-clean
clean:	nroff-clean
nroff-clean:
	$(RM) $(MAN1_SRC:%.1=%-1.pdf) $(MAN3_SRC:%.3=%-3.pdf) \
		$(MAN4_SRC:%.4=%-4.pdf)

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: nroff-todo
todo:	nroff-todo
nroff-todo:
	@$(ECHO) "++ make[$@]@$$PWD"
	@$(GREP) -e TODO -e FIXME -e REVISIT $(MAN1_SRC) $(MAN3_SRC) $(MAN4_SRC) /dev/null || true
