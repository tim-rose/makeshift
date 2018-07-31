#
# CMD.MK --Rules for building Microsoft bat/cmd/btm files.
#
# Contents:
# %.sh:           --Rules for installing shell scripts, libraries
# sh-src-defined: --Test that the CMD_SRC variable(s) are set.
# build-sh:       --Make scripts "executable".
# install-sh:     --install shell scripts to bindir, libraries to shlibdir
# uninstall-sh:   --uninstall files installed by "install-sh".
# clean:          --Remove shell, awk, sed script executables.
# toc:            --Build the table-of-contents for shell, awk, sed files.
# src:            --Define CMD_SRC, SHL_SRC, AWK_SRC, SED_SRC.
# todo:           --Report unfinished work in shell, awk, sed code.
# lint:           --Check sh style.
# install-shell:  --Compatibility targets
#
# Remarks:
.PHONY: $(recursive-targets:%=%-cmd)
ifdef autosrc
    LOCAL_CMD_SRC  := $(wildcard *.cmd)
    LOCAL_BAT_SRC  := $(wildcard *.bat)
    LOCAL_BTM_SRC  := $(wildcard *.btm)

    CMD_SRC	?= $(LOCAL_CMD_SRC)
    BAT_SRC	?= $(LOCAL_BAT_SRC)
    BTM_SRC	?= $(LOCAL_BTM_SRC)
endif

cmdlibdir	:= $(exec_prefix)/lib/cmd/$(subdir)

#
# %.cmd: --Rules for installing shell scripts, libraries
#
$(bindir)/%.cmd:	%.cmd;	$(INSTALL_SCRIPT) $*.cmd $@
$(bindir)/%.bat:	%.bat;	$(INSTALL_SCRIPT) $*.bat $@
$(cmdlibdir)/%.btm:	%.btm;	$(INSTALL_DATA) $*.btm $@


#
# install-cmd: --install shell scripts to bindir, libraries to shlibdir
#
install:	install-cmd
install-cmd:	$(CMD_SRC:%.cmd=$(bindir)/%.cmd) $(BAT_SRC:%.bat=$(bindir)/%.bat) \
    $(BTM_SRC:%.btm=$(cmdlibdir)/%.btm)
	$(ECHO_TARGET)

#
# uninstall-cmd: --uninstall files installed by "install-cmd".
#
uninstall:	uninstall-cmd
uninstall-cmd:
	$(ECHO_TARGET)
	$(RM) $(CMD_SRC:%.cmd=$(bindir)/%.cmd) $(BAT_SRC:%.bat=$(bindir)/%.bat) \
    $(BTM_SRC:%.btm=$(cmdlibdir)/%.btm)

	$(RMDIR) -p $(bindir) $(cmdlibdir) 2>/dev/null || true

#
# toc: --Build the table-of-contents for shell, awk, sed files.
#
# TODO: implement toc handling for batch files.
# toc:	toc-cmd
# toc-cmd:
# 	$(ECHO_TARGET)
# 	mk-toc $(CMD_SRC) $(BAT_SRC) $(BTM_SRC)

#
# src: --Define CMD_SRC, BAT_SRC, BTM_SRC.
#
src:	src-cmd
src-cmd:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn CMD_SRC *.cmd
	@mk-filelist -f $(MAKEFILE) -qn BAT_SRC *.bat
	@mk-filelist -f $(MAKEFILE) -qn BTM_SRC *.btm

#
# todo: --Report unfinished work in shell, awk, sed code.
#
todo:	todo-cmd
todo-cmd:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(ALL_CMD_SRC) /dev/null || true
