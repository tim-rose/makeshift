#
# MK.MK --devkit rules for manipulating ".mk" files.
#
# Contents:
# src-mk:  --Update MK_SRC with the list of ".mk" files.
# toc-mk:  --Rebuild a Makefile's table-of-contents.
# todo-mk: --Report unfinished work in Makefiles.
# +dirs:   --Print the current make directory macros.
#

$(includedir)/%.mk:	%.mk;	$(INSTALL_FILE) $< $@

#
# src-mk: --Update MK_SRC with the list of ".mk" files.
#
src:	src-mk
.PHONY: src-mk
src-mk:
	$(ECHO_TARGET)
	@mk-filelist -qn MK_SRC *.mk .mk

#
# toc-mk: --Rebuild a Makefile's table-of-contents.
#
toc:	toc-mk
.PHONY: toc-mk
toc-mk:
	$(ECHO_TARGET)
	@mk-toc Makefile $(MK_SRC)

#
# todo-mk: --Report unfinished work in Makefiles.
#
todo:	todo-mk
.PHONY: todo-mk
todo-mk:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(MK_SRC) /dev/null || true

#
# +dirs: --Print the current make directory macros.
#
.PHONY +stddirs:
+stddirs:
	@echo "DESTDIR:        $(DESTDIR)"
	@echo "prefix:         $(prefix)"
	@echo "opt:            $(opt)"
	@echo "usr:            $(usr)"
	@echo "subdir:         $(subdir)"
	@echo "archdir:        $(archdir)"
	@echo "rootdir:        $(rootdir)"
	@echo "bindir:         $(bindir)"
	@echo "sbindir:        $(sbindir)"
	@echo "libexecdir:     $(libexecdir)"
	@echo "datadir:        $(datadir)"
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
