#
# ELISP.MK --Rules for emacs lisp stuff.
#
# Contents:
# %.el:  --Rules for installing elisp scripts.
# build: --Compile elisp files using the emacs byte compiler.
# build: --byte-compile the elisp src.
# clean: --Remove byte-compiled elisp.
# toc:   --Build the table-of-contents for emacs lisp files.
# src:   --Update the ELISP_SRC macro with a list of ".el" files.
# todo:  --Report "unfinished work" comments in elisp files.
#
.PHONY: $(recursive-targets:%=%-elisp)

#
# %.el: --Rules for installing elisp scripts.
#
$(elispdir)/%.el:	%.el;	$(INSTALL_FILE) $? $@
$(elispdir)/%.elc:	%.elc;	$(INSTALL_FILE) $? $@

ELISP_OBJ = $(ELISP_SRC:%.el=%.elc)

#
# build: --Compile elisp files using the emacs byte compiler.
#
%.elc:	%.el
	emacs -batch -f batch-byte-compile $*.el



#
# build: --byte-compile the elisp src.
#
build:	build-elisp
build-elisp:	$(ELISP_OBJ)
	$(ECHO_TARGET)

#
# clean: --Remove byte-compiled elisp.
#
distclean:	clean-elisp
clean:	clean-elisp
clean-elisp:
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
