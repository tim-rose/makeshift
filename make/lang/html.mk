#
# HTML.MK --Rules for dealing with HTML files.
#
# Contents:
# html-toc: --Build the table-of-contents for shell, awk files.
# html-src: --html-specific customisations for the "src" target.
# tidy:     --html-specific customisations for the "tidy" target.
# todo:     --Report unfinished work (identified by keyword comments)
#
$(wwwdir)/%.html:	%.html;	$(INSTALL_FILE) $? $@

%.html:	%.md
	if markdown < $*.md >$*-body; then \
	    { echo "<html><body>"; cat $*-body; echo "</body></html>"; } >$@ ; \
	    $(RM) $*-body; \
	fi

#
# html-toc: --Build the table-of-contents for shell, awk files.
#
.PHONY: html-toc
toc:	html-toc
html-toc:
	$(ECHO_TARGET)
	mk-toc $(HTML_SRC)
#
# html-src: --html-specific customisations for the "src" target.
#
src:	html-src
.PHONY:	html-src
html-src:	
	$(ECHO_TARGET)
	@mk-filelist -qn HTML_SRC *.html

#
# tidy: --html-specific customisations for the "tidy" target.
#
tidy:	html-tidy
.PHONY:	html-tidy
html-tidy:
	$(ECHO_TARGET)
	 tidy -config $(DEVKIT_HOME)/etc/tidy.conf $(HTML_SRC)

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: html-todo
todo:	html-todo
html-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(HTML_SRC) /dev/null || true

