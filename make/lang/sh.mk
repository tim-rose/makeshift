#
# SHELL.MK --Rules for building shell, awk scripts and libraries.
#
# Contents:
# %.sh:                --Rules for installing shell scripts, libraries
# shell-build:         --Make scripts "executable".
# shell-src-var-defined: --Test if "enough" of the shell SRC vars. are defined.
# shell-clean:         --Remove script executables.
# awk-tidy:            --reformat/cleanup awk scripts
# shell-toc:           --Build the table-of-contents for shell, awk files.
# shell-src:           --shell-specific customisations for the "src" target.
# todo:                --Report unfinished work (identified by keyword comments)
#
shlibdir      = $(exec_prefix)/lib/sh/$(subdir)
SHELL_TRG = $(SH_SRC:%.sh=%) $(AWK_SRC:%.awk=%) $(SED_SRC:%.sed=%)
#
# %.sh: --Rules for installing shell scripts, libraries
#
%:			%.sh;	$(INSTALL_PROGRAM) $*.sh $@
%:			%.awk;	$(INSTALL_PROGRAM) $*.awk $@
%:			%.sed;	$(INSTALL_PROGRAM) $*.sed $@
$(shlibdir)/%.shl:	%.shl;	$(INSTALL_FILE) $*.shl $@
$(shlibdir)/%.awk:	%.awk;	$(INSTALL_FILE) $*.awk $@
$(shlibdir)/%.sed:	%.sed;	$(INSTALL_FILE) $*.sed $@

#
# shell-build: --Make scripts "executable".
#
pre-build:	shell-src-var-defined
build:	$(SHELL_TRG)

#
# shell-src-var-defined: --Test if "enough" of the shell SRC vars. are defined.
#
shell-src-var-defined:
	@if [ -z '$(SH_SRC)$(SHL_SRC)$(AWK_SRC)$(SED_SRC)' ]; then \
	    printf $(VAR_UNDEF) "SH_SRC, SHL_SRC, AWK_SRC or SED_SRC"; \
	    echo 'run "make src" to define them'; \
	    false; \
	fi >&2
#
# shell-clean: --Remove script executables.
#
.PHONY: shell-clean
clean:	shell-clean
shell-clean:
	$(RM) $(SHELL_TRG)

distclean:	shell-clean

#
# awk-tidy: --reformat/cleanup awk scripts
#
tidy:	$(AWK_SRC:%=awk-tidy[%])
awk-tidy[%]:
	$(ECHO_TARGET)
	awk-tidy $* >$*.tmp && mv $*.tmp $*
#
#
# shell-toc: --Build the table-of-contents for shell, awk files.
#
.PHONY: shell-toc
toc:	shell-toc
shell-toc:
	$(ECHO_TARGET)
	mk-toc $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC)
#
# shell-src: --shell-specific customisations for the "src" target.
#
src:	shell-src
.PHONY:	shell-src
shell-src:
	$(ECHO_TARGET)
	@mk-filelist -qn SH_SRC *.sh
	@mk-filelist -qn SHL_SRC *.shl
	@mk-filelist -qn AWK_SRC *.awk
	@mk-filelist -qn SED_SRC *.sed

#
# todo: --Report unfinished work (identified by keyword comments)
#
.PHONY: shell-todo
todo:	shell-todo
shell-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT \
	    $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC) /dev/null || true
