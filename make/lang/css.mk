#
# CSS.MK --Rules for dealing with CSS files.
#
# Contents:
# src-css: --Update the CSS_SRC, SCSS_SRC macros.
# toc-css: --Build the table-of-contents for CSS files.
# todo:    --Report "unfinished work" comments in CSS files.
#

$(wwwdir)/%.css:	%.css;	$(INSTALL_FILE) $? $@

%.css:	%.scss;	scss $? >$@
%.css:	%.less;	less $? >$@

#
# src-css: --Update the CSS_SRC, SCSS_SRC macros.
#
src:	src-css
.PHONY:	src-css
src-css:
	$(ECHO_TARGET)
	@mk-filelist -qn CSS_SRC *.css
	@mk-filelist -qn SCSS_SRC *.scss
	@mk-filelist -qn LESS_SRC *.less

#
# toc-css: --Build the table-of-contents for CSS files.
#
.PHONY: toc-css
toc:	toc-css
toc-css:
	$(ECHO_TARGET)
	mk-toc $(CSS_SRC) $(SCSS_SRC) $(LESS_SRC)

#
# todo: --Report "unfinished work" comments in CSS files.
#
.PHONY: todo-css
todo:	todo-css
todo-css:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(CSS_SRC) $(SCSS_SRC) $(LESS_SRC) /dev/null || true
