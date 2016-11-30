#
# ELISP.MK --Rules for emacs lisp stuff.
#
# Contents:
# %.el:            --Rules for installing elisp scripts.
# build:           --Compile elisp files using the emacs byte compiler.
# build:           --byte-compile the elisp src.
# install-elisp:   --install the compiled emacs files.
# uninstall-elisp: --uninstall the compiled emacs files.
# clean:           --Remove byte-compiled elisp.
# toc:             --Build the table-of-contents for emacs lisp files.
# src:             --Update the ELISP_SRC macro with a list of ".el" files.
# todo:            --Report "unfinished work" comments in elisp files.
#
.PHONY: $(recursive-targets:%=%-elisp)

#
# %.el: --Rules for installing elisp scripts.
#
$(elispdir)/%.el:	%.el;	$(INSTALL_DATA) $? $@
$(elispdir)/%.elc:	%.elc;	$(INSTALL_DATA) $? $@

ELISP_OBJ = $(ELISP_SRC:%.el=%.elc)

#
# build: --Compile elisp files using the emacs byte compiler.
#
%.elc:	%.el
	$(ECHO_TARGET)
	emacs -batch -f batch-byte-compile $*.el

#
# build: --byte-compile the elisp src.
#
build:	build-elisp
build-elisp:	$(ELISP_OBJ); 	$(ECHO_TARGET)


#
# install-elisp: --install the compiled emacs files.
#
install-elisp:	$(ELISP_OBJ:%.elc=$(elispdir)/%.elc)
	$(ECHO_TARGET)

#
# uninstall-elisp: --uninstall the compiled emacs files.
#
uninstall-elisp:
	$(ECHO_TARGET)
	$(RM) $(ELISP_OBJ:%.elc=$(elispdir)/%.elc)
	$(RMDIR) -p $(elispdir) 2>/dev/null || true

#
# clean: --Remove byte-compiled elisp.
#
distclean:	clean-elisp
clean:	clean-elisp
clean-elisp:
	$(ECHO_TARGET)
	$(RM) -f $(ELISP_OBJ)

#
# toc: --Build the table-of-contents for emacs lisp files.
#
toc:	toc-elisp
toc-elisp:	var-defined[ELISP_SRC]
	$(ECHO_TARGET)
	mk-toc $(ELISP_SRC)

#
# src: --Update the ELISP_SRC macro with a list of ".el" files.
#
src:	src-elisp
src-elisp:
	$(ECHO_TARGET)
	@mk-filelist -qn ELISP_SRC *.el

#
# todo: --Report "unfinished work" comments in elisp files.
#
todo:	todo-elisp
todo-elisp:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(ELISP_SRC) /dev/null || true
