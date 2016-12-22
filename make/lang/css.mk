#
# CSS.MK --Rules for dealing with CSS files.
#
# Contents:
# css-src-defined: --Test if any of the "css" SRC vars. are defined.
# install-css:     --install css files.
# uninstall-css:   --Uninstall the default ".css" files.
# src:             --Update the CSS_SRC, SCSS_SRC macros.
# toc:             --Build the table-of-contents for CSS files.
# todo:            --Report "unfinished work" comments in CSS files.
#
# Remarks:
# MAP_SRC is not defined, not all CSS files have them.
#
# TODO: macros for LESSC, SCSS (and choose tools)
#
.PHONY: $(recursive-targets:%=%-css)

ifdef autosrc
    LOCAL_CSS_SRC := $(wildcard *.css)
    LOCAL_SCSS_SRC := $(wildcard *.scss)
    LOCAL_LESS_SRC := $(wildcard *.less)

    CSS_SRC ?= $(LOCAL_CSS_SRC)
    SCSS_SRC ?= $(LOCAL_SCSS_SRC)
    LESS_SRC ?= $(LOCAL_LESS_SRC)
endif

$(wwwdir)/%.css:	%.css;		$(INSTALL_DATA) $? $@
$(datadir)/%.css:	%.css;		$(INSTALL_DATA) $? $@
$(wwwdir)/%.css.map:	%.css.map;	$(INSTALL_DATA) $? $@
$(datadir)/%.css.map:	%.css.map;	$(INSTALL_DATA) $? $@

%.css:	%.scss;	scss $*.scss >$@
%.css:	%.less;	plessc $*.less >$@

#
# css-src-defined: --Test if any of the "css" SRC vars. are defined.
#
css-src-defined:
	@if [ ! '$(CSS_SRC)$(SCSS_SRC)$(LESS_SRC)' ]; then \
	    printf $(VAR_UNDEF) "CSS_SRC, SCSS_SRC, LESS_SRC"; \
	    echo 'run "make src" to define them'; \
	    false; \
	fi >&2

#
# install-css: --install css files.
#
install-css:	$(CSS_SRC:%.css=$(wwwdir)/%.css) \
    $(CSS_MAP_SRC:%.css.map=$(wwwdir)/%.css.map)
	$(ECHO_TARGET)

#
# uninstall-css: --Uninstall the default ".css" files.
#
uninstall-css:
	$(ECHO_TARGET)
	$(RM) $(CSS_SRC:%.css=$(wwwdir)/%.css) $(CSS_MAP_SRC:%.css.map=$(wwwdir)/%.css.map)
	$(RMDIR) -p $(wwwdir) 2>/dev/null || true

#
# src: --Update the CSS_SRC, SCSS_SRC macros.
#
src:	src-css
src-css:
	$(ECHO_TARGET)
	@mk-filelist -qn CSS_SRC *.css
	@mk-filelist -qn SCSS_SRC *.scss
	@mk-filelist -qn LESS_SRC *.less

#
# toc: --Build the table-of-contents for CSS files.
#
toc:	toc-css
toc-css:	css-src-defined
	$(ECHO_TARGET)
	mk-toc $(CSS_SRC) $(SCSS_SRC) $(LESS_SRC)

#
# todo: --Report "unfinished work" comments in CSS files.
#
todo:	todo-css
todo-css:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(CSS_SRC) $(SCSS_SRC) $(LESS_SRC) /dev/null || true
