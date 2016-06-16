#
# SHELL.MK --Rules for building shell, awk scripts and libraries.
#
# Contents:
# %.sh:                --Rules for installing shell scripts, libraries
# shell-src-var-defined: --Test if "enough" of the shell SRC vars. are defined.
# build-shell:         --Make scripts "executable".
# install-shell:       --install shell scripts to bindir, libraries to shlibdir
# uninstall-shell:     --uninstall files installed by "install-shell".
# clean:               --Remove shell, awk, sed script executables.
# toc:                 --Build the table-of-contents for shell, awk, sed files.
# src:                 --Define SH_SRC, SHL_SRC, AWK_SRC, SED_SRC.
# todo:                --Report unfinished work in shell, awk, sed code.
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
shell-src-defined:
	@if [ -z '$(SH_SRC)$(SHL_SRC)$(AWK_SRC)$(SED_SRC)' ]; then \
	    printf $(VAR_UNDEF) "SH_SRC, SHL_SRC, AWK_SRC or SED_SRC"; \
	    echo 'run "make src" to define them'; \
	    false; \
	fi >&2

#
# build-shell: --Make scripts "executable".
#
pre-build:	shell-src-defined
build:	build-shell
build-shell:	$(SHELL_TRG)

#
# install-shell: --install shell scripts to bindir, libraries to shlibdir
#
install-shell:	$(SH_SRC:%.sh=$(bindir)/%) $(SHL_SRC:%=$(shlibdir)/%) \
    $(SED_SRC:%.sed=$(bindir)/%) $(AWK_SRC:%.awk=$(bindir)/%)
	$(ECHO_TARGET)

#
# uninstall-shell: --uninstall files installed by "install-shell".
#
uninstall-shell:
	$(ECHO_TARGET)
	$(RM) 	$(SH_SRC:%.sh=$(bindir)/%) $(SHL_SRC:%=$(shlibdir)/%) \
            $(SED_SRC:%.sed=$(bindir)/%) $(AWK_SRC:%.awk=$(bindir)/%)
	$(RMDIR) -p $(bindir) $(shlibdir) 2>/dev/null || true

#
# clean: --Remove shell, awk, sed script executables.
#
clean:	clean-shell
clean-shell:
	$(RM) $(SHELL_TRG)

distclean:	clean-shell

#
# toc: --Build the table-of-contents for shell, awk, sed files.
#
toc:	toc-shell
toc-shell:
	$(ECHO_TARGET)
	mk-toc $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC)
#
# src: --Define SH_SRC, SHL_SRC, AWK_SRC, SED_SRC.
#
src:	src-shell
src-shell:
	$(ECHO_TARGET)
	@mk-filelist -qn SH_SRC *.sh
	@mk-filelist -qn SHL_SRC *.shl
	@mk-filelist -qn AWK_SRC *.awk
	@mk-filelist -qn SED_SRC *.sed

#
# todo: --Report unfinished work in shell, awk, sed code.
#
todo:	todo-shell
todo-shell:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) \
	    $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC) /dev/null || true
