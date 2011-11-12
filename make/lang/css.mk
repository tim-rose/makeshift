#
# CSS.MK --Rules for dealing with CSS files.
#
# Contents:
# css-toc: --Build the table-of-contents for shell, awk files.
# css-src: --css-specific customisations for the "src" target.
# todo:    --Report unfinished work (identified by keyword comments)
#
$(wwwdir)/%.css:	%.css;	$(INSTALL_DATA) $? $@

#
# css-toc: --Build the table-of-contents for shell, awk files.
#
.PHONY: css-toc
toc:	css-toc
css-toc:
	@$(ECHO) "++ make[$@]@$$PWD"
	mk-toc $(CSS_SRC)
#
# css-src: --css-specific customisations for the "src" target.
#
src:	css-src
.PHONY:	css-src
css-src:	
	@$(ECHO) "++ make[$@]@$$PWD"
	@mk-filelist -qn CSS_SRC *.css

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: css-todo
todo:	css-todo
css-todo:
	@$(ECHO) "++ make[$@]@$$PWD"
	@$(GREP) -e TODO -e FIXME -e REVISIT $(CSS_SRC) /dev/null || true
