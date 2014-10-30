#
# LISP.MK --Rules for (emacs) lisp stuff.
#
# Contents:
# %.el:       --Rules for installing lisp scripts
# build:      --Compile lisp files using the emacs byte compiler.
# lisp-clean: --Remove lisp objects
# lisp-toc:   --Build the table-of-contents for LISP-ish files.
# lisp-src:   --Update the LISP_SRC macro.
# todo:       --Report "unfinished work" comments in lisp files.
#
# Remarks:
# One day when I get back to some serious lisp development I'll
# probably rename this to elisp.mk...
#

#
# %.el: --Rules for installing lisp scripts
#
$(lispdir)/%.el:	%.el;	$(INSTALL_FILE) $? $@
$(lispdir)/%.elc:	%.elc;	$(INSTALL_FILE) $? $@

LISP_OBJ = $(LISP_SRC:%.el=%.elc)

#
# build: --Compile lisp files using the emacs byte compiler.
#
%.elc:	%.el
	emacs -batch -f batch-byte-compile $*.el
pre-build:	src-var-defined[LISP_SRC]
build:	$(LISP_OBJ)

#
# lisp-clean: --Remove lisp objects
#
distclean:	lisp-clean
clean:	lisp-clean
.PHONY: lisp-clean
lisp-clean:
	$(RM) $(LISP_OBJ)

#
# lisp-toc: --Build the table-of-contents for LISP-ish files.
#
.PHONY: lisp-toc
toc:	lisp-toc
lisp-toc:
	$(ECHO_TARGET)
	mk-toc $(LISP_SRC)

#
# lisp-src: --Update the LISP_SRC macro.
#
src:	lisp-src
.PHONY:	lisp-src
lisp-src:
	$(ECHO_TARGET)
	@mk-filelist -qn LISP_SRC *.el

#
# todo: --Report "unfinished work" comments in lisp files.
#
.PHONY: lisp-todo
todo:	lisp-todo
lisp-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(LISP_SRC) /dev/null || true
