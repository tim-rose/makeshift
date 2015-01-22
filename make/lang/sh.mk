#
# SHELL.MK --Rules for building shell, awk scripts and libraries.
#
# Contents:
# %.sh:                --Rules for installing shell scripts, libraries
# build-shell:         --Make scripts "executable".
# shell-src-var-defined: --Test if "enough" of the shell SRC vars. are defined.
# clean-shell:         --Remove script executables.
# tidy-awk:            --reformat/cleanup awk scripts
# toc-shell:           --Build the table-of-contents for shell, awk files.
# src-shell:           --shell-specific customisations for the "src" target.
# todo-shell:          --Report unfinished work in shell code.
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
# build-shell: --Make scripts "executable".
#
pre-build:	src-shell-var-defined
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
# clean-shell: --Remove script executables.
#
.PHONY: clean-shell
clean:	clean-shell
clean-shell:
	$(RM) $(SHELL_TRG)

distclean:	clean-shell

#
# tidy-awk: --reformat/cleanup awk scripts
#
tidy:	$(AWK_SRC:%=tidy-awk[%])
tidy-awk[%]:
	$(ECHO_TARGET)
	tidy-awk $* >$*.tmp && mv $*.tmp $*
#
#
# toc-shell: --Build the table-of-contents for shell, awk files.
#
.PHONY: toc-shell
toc:	toc-shell
toc-shell:
	$(ECHO_TARGET)
	mk-toc $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC)
#
# src-shell: --shell-specific customisations for the "src" target.
#
src:	src-shell
.PHONY:	src-shell
src-shell:
	$(ECHO_TARGET)
	@mk-filelist -qn SH_SRC *.sh
	@mk-filelist -qn SHL_SRC *.shl
	@mk-filelist -qn AWK_SRC *.awk
	@mk-filelist -qn SED_SRC *.sed

#
# todo-shell: --Report unfinished work in shell code.
#
.PHONY: todo-shell
todo:	todo-shell
todo-shell:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT \
	    $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC) /dev/null || true
