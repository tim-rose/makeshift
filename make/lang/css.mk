#
# CSS.MK --Rules for dealing with CSS files.
#
# Contents:
# src-css:  --Update the CSS_SRC, SCSS_SRC macros.
# toc-css:  --Build the table-of-contents for CSS files.
# todo-css: --Report "unfinished work" comments in CSS files.
#
# Remarks:
# MAP_SRC is not defined, not all CSS files have them.
#
# TODO: macros for LESSC, SCSS (and choose tools)
#
.PHONY: $(recursive-targets:%=%-css)

$(wwwdir)/%.css:	%.css;		$(INSTALL_FILE) $? $@
$(datadir)/%.css:	%.css;		$(INSTALL_FILE) $? $@
$(wwwdir)/%.css.map:	%.css.map;	$(INSTALL_FILE) $? $@
$(datadir)/%.css.map:	%.css.map;	$(INSTALL_FILE) $? $@

%.css:	%.scss;	scss $*.scss >$@
%.css:	%.less;	plessc $*.less >$@

#
# install-css: --install css files.
#
install-css:	$(CSS_SRC:%.css=$(wwwdir)/%.css) \
    $(CSS_MAP_SRC:%.css.map=$(wwwdir)/%.css.map)

#
# src-css: --Update the CSS_SRC, SCSS_SRC macros.
#
src:	src-css
src-css:
	$(ECHO_TARGET)
	@mk-filelist -qn CSS_SRC *.css
	@mk-filelist -qn SCSS_SRC *.scss
	@mk-filelist -qn LESS_SRC *.less

#
# toc-css: --Build the table-of-contents for CSS files.
#
toc:	toc-css
toc-css:
	$(ECHO_TARGET)
	mk-toc $(CSS_SRC) $(SCSS_SRC) $(LESS_SRC)

#
# todo-css: --Report "unfinished work" comments in CSS files.
#
todo:	todo-css
todo-css:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(CSS_SRC) $(SCSS_SRC) $(LESS_SRC) /dev/null || true
