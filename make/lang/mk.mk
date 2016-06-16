#
# MK.MK --devkit rules for manipulating ".mk" files.
#
# Contents:
# install-mk:   --Install ".mk" files to their usual places.
# uninstall-mk: --Uninstall the default ".mk" files.
# src:          --Update MK_SRC with the list of ".mk" files.
# toc:          --Rebuild a Makefile's table-of-contents.
# todo:         --Report unfinished work in Makefiles.
# +stddirs:     --Print the current make directory macros.
#
.PHONY: $(recursive-targets:%=%-mk)

ifdef AUTOSRC
    DEFAULT_MK_SRC := $(wildcard *.mk)

    MK_SRC ?= $(DEFAULT_MK_SRC)
endif

$(includedir)/%.mk:	%.mk;	$(INSTALL_FILE) $< $@

#
# install-mk: --Install ".mk" files to their usual places.
#
install-mk:     $(MK_SRC:%.mk=$(includedir)/%.mk)

#
# uninstall-mk: --Uninstall the default ".mk" files.
#
uninstall-mk:
	$(ECHO_TARGET)
	$(RM) $(MK_SRC:%.mk=$(includedir)/%.mk)
	$(RMDIR) -p $(includedir) 2>/dev/null || true

#
# src: --Update MK_SRC with the list of ".mk" files.
#
src:	src-mk
src-mk:
	$(ECHO_TARGET)
	@mk-filelist -qn MK_SRC *.mk .mk

#
# toc: --Rebuild a Makefile's table-of-contents.
#
toc:	toc-mk
toc-mk:
	$(ECHO_TARGET)
	@mk-toc Makefile $(MK_SRC)

#
# todo: --Report unfinished work in Makefiles.
#
todo:	todo-mk
todo-mk:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) Makefile $(MK_SRC) /dev/null || true

#
# +stddirs: --Print the current make directory macros.
#
.PHONY +stddirs:
+stddirs:
	@echo "DESTDIR:        $(DESTDIR)"
	@echo "prefix:         $(prefix)"
	@echo "opt:            $(opt)"
	@echo "usr:            $(usr)"
	@echo "subdir:         $(subdir)"
	@echo "archdir:        $(archdir)"
	@echo "pkgver:         $(pkgver)"
	@echo ""; echo "rootdir:        $(rootdir)"
	@echo "bindir:         $(bindir)"
	@echo "sbindir:        $(sbindir)"
	@echo "libexecdir:     $(libexecdir)"
	@echo "datadir:        $(datadir)"
	@echo "system_confdir: $(system_confdir)"
	@echo "sysconfdir:     $(sysconfdir)"
	@echo "divertdir:      $(divertdir)"
	@echo "sharedstatedir: $(sharedstatedir)"
	@echo "localstatedir:  $(localstatedir)"
	@echo "srvdir:         $(srvdir)"
	@echo "wwwdir:         $(wwwdir)"
	@echo "libdir:         $(libdir)"
	@echo "infodir:        $(infodir)"
	@echo "lispdir:        $(lispdir)"
	@echo "includedir:     $(includedir)"
	@echo "mandir:         $(mandir)"
	@echo "docdir:         $(docdir)"
