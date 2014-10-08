#
# MK.MK --devkit rules for manipulating ".mk" files.
#
# Contents:
# todo: --Report unfinished work (identified by keyword comments)
#
# Remarks:
# "lang/mk" contains rules for managing makefiles.  These are just
# customisations of the standard make targets.
#
$(libexecdir)/%.mk:	%.mk;	$(INSTALL_FILE) $< $@

src:	mk-src
.PHONY: mk-src
mk-src:
	$(ECHO_TARGET)
	@mk-filelist -qn MK_SRC *.mk .mk

toc:	_mk-toc
.PHONY: _mk-toc
_mk-toc:
	$(ECHO_TARGET)
	@mk-toc Makefile $(MK_SRC)

#
# todo: --Report unfinished work (identified by keyword comments)
#
todo:	mk-todo
.PHONY: mk-todo
mk-todo:
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
