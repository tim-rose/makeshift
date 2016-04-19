#
# ELISP.MK --Rules for emacs lisp stuff.
#
# Contents:
# %.el:        --Rules for installing elisp scripts.
# build:       --Compile elisp files using the emacs byte compiler.
# clean-elisp: --Remove byte-compiled elisp.
# toc-elisp:   --Build the table-of-contents for emacs lisp files.
# src-elisp:   --Update the ELISP_SRC macro with a list of ".el" files.
# todo:        --Report "unfinished work" comments in elisp files.
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
pre-build:
build:	$(ELISP_OBJ)

#
# clean-elisp: --Remove byte-compiled elisp.
#
distclean:	clean-elisp
clean:	clean-elisp

clean-elisp:
	$(RM) $(ELISP_OBJ)

#
# toc-elisp: --Build the table-of-contents for emacs lisp files.
#
toc:	toc-elisp
toc-elisp:
	$(ECHO_TARGET)
	mk-toc $(ELISP_SRC)

#
# src-elisp: --Update the ELISP_SRC macro with a list of ".el" files.
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
