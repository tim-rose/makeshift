#
# SHELL.MK --Rules for building shell, awk scripts and libraries.
#
# Contents:
# %.sh:                --Rules for installing shell scripts, libraries
# shell-src-var-defined: --Test if "enough" of the shell SRC vars. are defined.
# build-shell:         --Make scripts "executable".
# install-shell:       --install shell scripts to bindir, libraries to shlibdir
# clean-shell:         --Remove script executables.
# toc-shell:           --Build the table-of-contents for shell, awk files.
# src-shell:           --shell-specific customisations for the "src" target.
# todo-shell:          --Report unfinished work in shell code.
#
# Remarks:
# For the purposes of building stuff, "shell" covers the "traditional"
# Unix scripting languages (sh, sed and awk).  It requires some of
# the following variables to be defined:
#
#  * SH_SRC	--shell scripts
#  * SHL_SRC	--shell library files
#  * AWK_SRC	--awk scripts
#  * SED_SRC	--sed scripts
#
# It defines rules for building and installing, and for installing
# library files into a shell-specific library directory $(shlibdir).
# The target `install-shell` will install scripts into $(bindir).
#
.PHONY: $(recursive-targets:%=%-shell)
SH_SRC	?= $(wildcard *.sh)
SHL_SRC	?= $(wildcard *.shl)
AWK_SRC	?= $(wildcard *.awk)
SED_SRC	?= $(wildcard *.sed)

shlibdir	:= $(exec_prefix)/lib/sh/$(subdir)
SHELL_TRG	:= $(SH_SRC:%.sh=%) $(AWK_SRC:%.awk=%) $(SED_SRC:%.sed=%)
#
# %.sh: --Rules for installing shell scripts, libraries
#
%:			%.sh;	$(CP) $*.sh $@ && $(CHMOD) +x $@
%:			%.awk;	$(CP) $*.awk $@ && $(CHMOD) +x $@
%:			%.sed;	$(CP) $*.sed $@ && $(CHMOD) +x $@
$(shlibdir)/%.shl:	%.shl;	$(INSTALL_FILE) $*.shl $@
$(shlibdir)/%.awk:	%.awk;	$(INSTALL_FILE) $*.awk $@
$(shlibdir)/%.sed:	%.sed;	$(INSTALL_FILE) $*.sed $@

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
# build-shell: --Make scripts "executable".
#
pre-build:	shell-src-var-defined
build:	$(SHELL_TRG)

$(SHELL_TRG): | pre-build

#
# install-shell: --install shell scripts to bindir, libraries to shlibdir
#
install-shell:	$(SH_SRC:%.sh=$(bindir)/%) $(SHL_SRC:%=$(shlibdir)/%) \
	$(SED_SRC:%.sed=$(bindir)/%) $(AWK_SRC:%.awk=$(bindir)/%)

#
# clean-shell: --Remove script executables.
#
clean:	clean-shell
clean-shell:
	$(RM) $(SHELL_TRG)

distclean:	clean-shell

#
# toc-shell: --Build the table-of-contents for shell, awk files.
#
toc:	toc-shell
toc-shell:
	$(ECHO_TARGET)
	mk-toc $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC)
#
# src-shell: --shell-specific customisations for the "src" target.
#
src:	src-shell
src-shell:
	$(ECHO_TARGET)
	@mk-filelist -qn SH_SRC *.sh
	@mk-filelist -qn SHL_SRC *.shl
	@mk-filelist -qn AWK_SRC *.awk
	@mk-filelist -qn SED_SRC *.sed

#
# todo-shell: --Report unfinished work in shell code.
#
todo:	todo-shell
todo-shell:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT \
	    $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC) /dev/null || true
