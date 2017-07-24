#
# SHELL.MK --Rules for building shell, awk scripts and libraries.
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
    LOCAL_AWK_SRC := $(wildcard *.awk)
    LOCAL_SED_SRC := $(wildcard *.sed)

    SH_SRC	?= $(LOCAL_SH_SRC)
    SHL_SRC	?= $(LOCAL_SHL_SRC)
    AWK_SRC	?= $(LOCAL_AWK_SRC)
    SED_SRC	?= $(LOCAL_SED_SRC)
endif

shlibdir	:= $(exec_prefix)/lib/sh/$(subdir)
SHELL_TRG	:= $(SH_SRC:%.sh=%) $(AWK_SRC:%.awk=%) $(SED_SRC:%.sed=%)
#
# %.sh: --Rules for installing shell scripts, libraries
#
%:			%.sh;	$(CP) $*.sh $@ && $(CHMOD) +x $@
%:			%.awk;	$(CP) $*.awk $@ && $(CHMOD) +x $@
%:			%.sed;	$(CP) $*.sed $@ && $(CHMOD) +x $@
$(bindir)/%:		%.sh;	$(INSTALL_SCRIPT) $*.sh $@
$(bindir)/%:		%.sed;	$(INSTALL_SCRIPT) $*.sed $@
$(bindir)/%:		%.awk;	$(INSTALL_SCRIPT) $*.swk $@
$(shlibdir)/%.shl:	%.shl;	$(INSTALL_DATA) $*.shl $@
$(shlibdir)/%.awk:	%.awk;	$(INSTALL_DATA) $*.awk $@
$(shlibdir)/%.sed:	%.sed;	$(INSTALL_DATA) $*.sed $@

#
# build-sh: --Make scripts "executable".
#
pre-build:
build:	build-sh
build-sh:	$(SHELL_TRG)

#
# install-sh: --install shell scripts to bindir, libraries to shlibdir
#
install-sh:	$(SH_SRC:%.sh=$(bindir)/%) $(SHL_SRC:%=$(shlibdir)/%) \
    $(SED_SRC:%.sed=$(bindir)/%) $(AWK_SRC:%.awk=$(bindir)/%)
	$(ECHO_TARGET)

#
# uninstall-sh: --uninstall files installed by "install-sh".
#
uninstall-sh:
	$(ECHO_TARGET)
	$(RM) $(SH_SRC:%.sh=$(bindir)/%) $(SHL_SRC:%=$(shlibdir)/%) \
            $(SED_SRC:%.sed=$(bindir)/%) $(AWK_SRC:%.awk=$(bindir)/%)
	$(RMDIR) -p $(bindir) $(shlibdir) 2>/dev/null || true

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
	mk-toc $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC)
#
# src: --Define SH_SRC, SHL_SRC, AWK_SRC, SED_SRC.
#
src:	src-sh
src-sh:
	$(ECHO_TARGET)
	@mk-filelist -qn SH_SRC *.sh
	@mk-filelist -qn SHL_SRC *.shl
	@mk-filelist -qn AWK_SRC *.awk
	@mk-filelist -qn SED_SRC *.sed

#
# todo: --Report unfinished work in shell, awk, sed code.
#
todo:	todo-sh
todo-sh:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) \
	    $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC) /dev/null || true

#
# lint: --Check sh style.
#
SH_LINT ?= shellcheck
SH_LINT_FLAGS = $(OS.SH_LINT_FLAGS) $(ARCH.SH_LINT_FLAGS) \
    $(PROJECT.SH_LINT_FLAGS) $(LOCAL.SH_LINT_FLAGS) $(TARGET.SH_LINT_FLAGS)
lint:	lint-sh
lint-sh:	c-src-defined
	$(ECHO_TARGET)
	$(SH_LINT) $(SH_LINT_FLAGS) $(SH_SRC) $(SHL_SRC)
#
# install-shell: --Compatibility targets
#
.PHONY:	install-shell
install-shell:  install-sh; $(warning target "install-shell" is deprecated)

.PHONY:	uninstall-shell
uninstall-shell:  uninstall-sh; $(warning target "uninstall-shell" is deprecated)
