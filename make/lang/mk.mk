#
# LANG-MK.MK --devkit rules for manipulating ".mk" files.
#
# Contents:
# todo:      --Report unfinished work (identified by keyword comments)
# show-env:  --Print the current make environment.
# show-dirs: --Print the current make directory macros.
#
$(libexecdir)/%.mk:	%.mk;	$(INSTALL_FILE) $< $@

.PHONY: mk-src
src:	mk-src
mk-src:
	@mk-filelist -qn MK_SRC *.mk .mk

.PHONY: mk-toc
toc:	mk-toc
mk-toc:
	mk-toc Makefile $(MK_SRC)

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: mk-todo
todo:	mk-todo
mk-todo:
	@$(ECHO) "++ make[$@]@$$PWD"
	@$(GREP) -e TODO -e FIXME -e REVISIT $(MK_SRC) /dev/null || true

#
# show-env: --Print the current make environment.
#
# Remarks:
# This is a debugging aid.
# These should probably be in targets.mk, but they're so closely tied
# to the above macros that I feel they kinda belong here.
# 
.PHONY:	show-env
show-env:
	@$(ECHO) "++ make[$@]@$$PWD"
	@echo "MAKE:           $(MAKE)"
	@echo "MAKEFLAGS:      $(MAKEFLAGS)"
	@echo "shell:          $(SHELL)"

#
# show-dirs: --Print the current make directory macros.
#
# Remarks:
# This is a debugging aid.
# 
.PHONY show-dirs:
show-dirs:
	@$(ECHO) "++ make[$@]@$$PWD"
	@echo "DESTDIR:         $(DESTDIR)"
	@echo "prefix:         $(prefix)"
	@echo "opt:            $(opt)"
	@echo "archdir:        $(archdir)"
	@echo "exec_prefix:    $(exec_prefix)"
	@echo "bindir:         $(bindir)"
	@echo "sbindir:        $(sbindir)"
	@echo "libexecdir:     $(libexecdir)"
	@echo "datadir:        $(datadir)"
	@echo "sysconfdir:     $(sysconfdir)"
	@echo "sharedstatedir: $(sharedstatedir)"
	@echo "localstatedir:  $(localstatedir)"
	@echo "libdir:         $(libdir)"
	@echo "perllibdir:     $(perllibdir)"
	@echo "infodir:        $(infodir)"
	@echo "lispdir:        $(lispdir)"
	@echo "includedir:     $(includedir)"
	@echo "mandir:         $(mandir)"
	@echo "man1dir:        $(man1dir)"
	@echo "man3dir:        $(man3dir)"
	@echo "man4dir:        $(man4dir)"
