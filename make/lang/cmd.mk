#
# CMD.MK --Rules for building Microsoft bat/cmd/btm files.
#
# Contents:
# %.cmd:         --Rules for installing cmd/bat commands, libraries
# install-cmd:   --install commands scripts to bindir, libraries to cmdlibdir
# uninstall-cmd: --uninstall files installed by "install-cmd".
# toc:           --Build the table-of-contents for cmd files
# src:           --Define CMD_SRC, BAT_SRC, BTM_SRC.
# todo:          --Report unfinished work in cmd code.
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
# %.cmd: --Rules for installing cmd/bat commands, libraries
#
$(bindir)/%.cmd:	%.cmd;	$(INSTALL_SCRIPT) $*.cmd $@
$(bindir)/%.bat:	%.bat;	$(INSTALL_SCRIPT) $*.bat $@
$(cmdlibdir)/%.btm:	%.btm;	$(INSTALL_DATA) $*.btm $@


#
# install-cmd: --install commands scripts to bindir, libraries to cmdlibdir
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

	$(RMDIR) $(bindir) $(cmdlibdir)

#
# toc: --Build the table-of-contents for cmd files
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
	$(Q)mk-filelist -f $(MAKEFILE) -qn CMD_SRC *.cmd
	$(Q)mk-filelist -f $(MAKEFILE) -qn BAT_SRC *.bat
	$(Q)mk-filelist -f $(MAKEFILE) -qn BTM_SRC *.btm

#
# todo: --Report unfinished work in cmd code.
#
todo:	todo-cmd
todo-cmd:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(ALL_CMD_SRC) /dev/null ||:
