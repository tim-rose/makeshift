#
# SHELL.MK --Rules for building shell, awk scripts andk libraries.
#
# Contents:
# %.sh:                --Rules for installing shell scripts, libraries
# %.awk:               --Rules for installing awk scripts
# shell-build:         --Make scripts "executable".
# shell-src-var-defined: --Test if "enough" of the shell SRC vars. are defined.
# shell-clean:         --Remove script executables.
# shell-toc:           --Build the table-of-contents for shell, awk files.
# shell-src:           --shell-specific customisations for the "src" target.
# todo:                --Report unfinished work (identified by keyword comments)
#
SHELL_TRG = $(SH_SRC:%.sh=%) $(AWK_SRC:%.awk=%) $(SED_SRC:%.sed=%) 
#
# %.sh: --Rules for installing shell scripts, libraries
#
%:			%.sh;	$(INSTALL_PROGRAM) $? $@
$(bindir)/%:		%.sh;	$(INSTALL_PROGRAM) $? $@
$(sbindir)/%:		%.sh;	$(INSTALL_PROGRAM) $? $@
$(libexecdir)/%:	%.sh;	$(INSTALL_PROGRAM) $? $@
$(libexecdir)/%.shl:	%.shl;	$(INSTALL_FILE) $? $@
$(sysconfdir)/%:	%.sh;	$(INSTALL_PROGRAM) $? $@

#
# %.awk: --Rules for installing awk scripts
#
%:			%.awk;	@$(INSTALL_SCRIPT) "$(AWK_PATH)" $? $@
$(bindir)/%:		%.awk;	@$(INSTALL_SCRIPT) "$(AWK_PATH)" $? $@
$(libexecdir)/%:	%.awk;	$(INSTALL_PROGRAM) $? $@

#
# %.sed: --Rules for installing sed scripts
#
%:			%.sed;	@$(INSTALL_SCRIPT) "$(SED_PATH)" $? $@
$(bindir)/%:		%.sed;	@$(INSTALL_SCRIPT) "$(SED_PATH)" $? $@
$(libexecdir)/%:	%.sed;	$(INSTALL_PROGRAM) $? $@

#
# shell-build: --Make scripts "executable".
#
pre-build:	shell-src-var-defined
build:	$(SHELL_TRG)

#
# shell-src-var-defined: --Test if "enough" of the shell SRC vars. are defined.
#
shell-src-var-defined:
	@test -n "$(SH_SRC)" -o -n "$(SHL_SRC)" -o -n "$(AWK_SRC)" -o -n "$(SED_SRC)" || \
	    { $(VAR_UNDEFINED) "SH_SRC, SHL_SRC, AWK_SRC or SED_SRC"; }

#
# shell-clean: --Remove script executables.
#
.PHONY: shell-clean
clean:	shell-clean
shell-clean:
	$(RM) $(SHELL_TRG)

distclean:	shell-clean

#
# shell-toc: --Build the table-of-contents for shell, awk files.
#
.PHONY: shell-toc
toc:	shell-toc
shell-toc:
	$(ECHO_TARGET)
	mk-toc $(SH_SRC) $(SHL_SRC) $(AWK_SRC)
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
