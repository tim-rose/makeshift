#
# SH.MK --Rules for building shell, awk scripts and libraries.
#
# Contents:
# %.sh:          --Rules for installing shell scripts, libraries
# build-sh:      --Make scripts "executable".
# install-sh:    --install shell scripts to bindir, libraries to shlibdir
# uninstall-sh:  --uninstall files installed by "install-sh".
# clean:         --Remove shell, awk, sed script executables.
# toc:           --Build the table-of-contents for shell, awk, sed files.
# src:           --Define SH_SRC, SHL_SRC, AWK_SRC, SED_SRC.
# todo:          --Report unfinished work in shell, awk, sed code.
# lint:          --Check sh style.
# install-shell: --Compatibility targets
#
# Remarks:
# For the purposes of building stuff, "shell" covers the "traditional"
# Unix scripting languages (sh, sed and awk).  It requires some of
# the following variables to be defined:
#
#  * SH_SRC	--sh scripts
#  * SHL_SRC	--sh library files
#  * AWK_SRC	--awk scripts
#  * SED_SRC	--sed scripts
#
# It defines rules for building and installing, and for installing
# library files into a shell-specific library directory $(shlibdir).
# The target `install-sh` will install scripts into $(bindir).
#
.PHONY: $(recursive-targets:%=%-sh)
ifdef autosrc
    LOCAL_SH_SRC  := $(wildcard *.sh)
    LOCAL_SHL_SRC := $(wildcard *.shl)
    LOCAL_RC_SRC := $(wildcard _*)
    LOCAL_AWK_SRC := $(wildcard *.awk)
    LOCAL_SED_SRC := $(wildcard *.sed)

    SH_SRC	?= $(LOCAL_SH_SRC)
    SHL_SRC	?= $(LOCAL_SHL_SRC)
    RC_SRC	?= $(LOCAL_RC_SRC)
    AWK_SRC	?= $(LOCAL_AWK_SRC)
    SED_SRC	?= $(LOCAL_SED_SRC)
endif

shlibdir	:= $(exec_prefix)/lib/sh/$(subdir)
SH_TRG	:= $(SH_SRC:%.sh=$(archdir)/%)
AWK_TRG	:= $(AWK_SRC:%.awk=$(archdir)/%)
SED_TRG	:= $(SED_SRC:%.sed=$(archdir)/%)
SHELL_TRG := $(SH_TRG) $(AWK_TRG) $(SED_TRG)

SET_VERSION = $(SED) -e '/^ [A-Z_]*VERSION=/s/=.*/=$(VERSION)/'

#
# %.sh: --Rules for installing shell scripts, libraries
#
$(archdir)/%:		%.sh;	$(SET_VERSION) < $*.sh > $@ && $(CHMOD) +x $@
$(archdir)/%:		%.awk;	$(SET_VERSION) < $*.awk >$@ && $(CHMOD) +x $@
$(archdir)/%:		%.sed;	$(SET_VERSION) < $*.sed > $@ && $(CHMOD) +x $@

$(sysconfdir)/%:	%;	$(INSTALL_DATA) $* $@ # bash completions
$(sysconfdir)/.%:	_%;	$(INSTALL_DATA) _$* $@ # rc files

$(shlibdir)/%.shl:	%.shl;	$(INSTALL_DATA) $*.shl $@
$(shlibdir)/%.awk:	%.awk;	$(INSTALL_DATA) $*.awk $@
$(shlibdir)/%.sed:	%.sed;	$(INSTALL_DATA) $*.sed $@

$(SHELL_TRG): | $(archdir)
#
# build-sh: --Make scripts "executable".
#
pre-build:
build:	build-sh
build-sh:	$(SHELL_TRG)
build[%.sh]:	$(archdir)/$*
build[%.awk]:	$(archdir)/$*
build[%.sed]:	$(archdir)/$*

#
# install-sh: --install shell scripts to bindir, libraries to shlibdir
#
install-sh:	$(SHELL_TRG:$(archdir)/%=$(bindir)/%) $(SHL_SRC:%=$(shlibdir)/%)
	$(ECHO_TARGET)

#
# uninstall-sh: --uninstall files installed by "install-sh".
#
uninstall-sh:
	$(ECHO_TARGET)
	$(RM) $(SHELL_TRG:$(archdir)/%=$(bindir)/%) $(SHL_SRC:%=$(shlibdir)/%)
	$(RMDIR) $(bindir) $(shlibdir)

#
# clean: --Remove shell, awk, sed script executables.
#
clean:	clean-sh
clean-sh:
	$(RM) $(SHELL_TRG)

distclean:	clean-sh

#
# toc: --Build the table-of-contents for shell, awk, sed files.
#
toc:	toc-sh
toc-sh:
	$(ECHO_TARGET)
	mk-toc -t .sh $(SH_SRC) $(SHL_SRC) $(RC_SRC) $(AWK_SRC) $(SED_SRC)
#
# src: --Define SH_SRC, SHL_SRC, AWK_SRC, SED_SRC.
#
src:	src-sh
src-sh:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qn SH_SRC *.sh
	$(Q)mk-filelist -f $(MAKEFILE) -qn SHL_SRC *.shl
	$(Q)mk-filelist -f $(MAKEFILE) -qn RC_SRC _*
	$(Q)mk-filelist -f $(MAKEFILE) -qn AWK_SRC *.awk
	$(Q)mk-filelist -f $(MAKEFILE) -qn SED_SRC *.sed

#
# todo: --Report unfinished work in shell, awk, sed code.
#
todo:	todo-sh
todo-sh:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) \
	    $(SH_SRC) $(SHL_SRC) $(RC_SRC) $(AWK_SRC) $(SED_SRC) /dev/null ||:

#
# lint: --Check sh style.
#
SH_LINT ?= shellcheck -x -s dash
SH_LINT_FLAGS = $(OS.SH_LINT_FLAGS) $(ARCH.SH_LINT_FLAGS) \
    $(PROJECT.SH_LINT_FLAGS) $(LOCAL.SH_LINT_FLAGS) $(TARGET.SH_LINT_FLAGS)
lint:	lint-sh
lint-sh:
	$(ECHO_TARGET)
	-$(SH_LINT) $(SH_LINT_FLAGS) $(SH_SRC) $(SHL_SRC)
lint[%.sh]:
	$(ECHO_TARGET)
	-$(SH_LINT) $(SH_LINT_FLAGS) $*.sh
lint[%.shl]:
	$(ECHO_TARGET)
	-$(SH_LINT) $(SH_LINT_FLAGS) $*.shl

#
# install-shell: --Compatibility targets
#
.PHONY:	install-shell
install-shell:  install-sh; $(warning target "install-shell" is deprecated)

.PHONY:	uninstall-shell
uninstall-shell:  uninstall-sh; $(warning target "uninstall-shell" is deprecated)
