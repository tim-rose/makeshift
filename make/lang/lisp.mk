#
# LISP.MK --Rules for (emacs) lisp stuff.
#
# Contents:
# lisp-clean: --Remove lisp binaries built from source.
# lisp-toc:   --Build the table-of-contents for LISP-ish files.
# lisp-src:   --lisp-specific customisations for the "src" target.
# todo:       --Report unfinished work (identified by keyword comments)
#
# Remarks:
# One day when I get back to some serious lisp development I'll
# probably rename this to elisp.mk...
#
LISP_TRG = $(LISP_SRC:%.el=%.elc)

#
# lisp-build:	--Compile lisp files using the emacs byte compiler.
#
%.elc:	%.el
	emacs -batch -f batch-byte-compile $*.el
pre-build:	src-var-defined[LISP_SRC]
build:	$(LISP_TRG)

#
# lisp-clean: --Remove lisp binaries built from source.
#
.PHONY: lisp-clean
clean:	lisp-clean
lisp-clean:
	$(RM) $(LISP_TRG)

distclean:	lisp-clean

#
# %.el:		--Rules for installing lisp scripts
#
$(lispdir)/%.el:	%.el;	$(INSTALL_FILE) $? $@
$(lispdir)/%.elc:	%.elc;	$(INSTALL_FILE) $? $@

#
# lisp-toc: --Build the table-of-contents for LISP-ish files.
#
.PHONY: lisp-toc
toc:	lisp-toc
lisp-toc:
	@$(ECHO) "++ make[$@]@$$PWD"
	mk-toc $(LISP_SRC)

#
# lisp-src: --lisp-specific customisations for the "src" target.
#
src:	lisp-src
.PHONY:	lisp-src
lisp-src:	
	@$(ECHO) "++ make[$@]@$$PWD"
	@mk-filelist -qn LISP_SRC *.el

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: lisp-todo
todo:	lisp-todo
lisp-todo:
	@$(ECHO) "++ make[$@]@$$PWD"
	@$(GREP) -e TODO -e FIXME -e REVISIT $(LISP_SRC) /dev/null || true
