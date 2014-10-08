#
# HTML.MK --Rules for dealing with HTML files.
#
# Contents:
# md-src: --markdown-specific customisations for the "src" target.
# todo:   --Report unfinished work (identified by keyword comments)
#
$(wwwdir)/%.html:	%.html;	$(INSTALL_FILE) $? $@

%.html:	%.md
	if markdown $*.md >$*-body; then \
	    { echo "<html><body>"; cat $*-body; echo "</body></html>"; } >$@ ; \
	    $(RM) $*-body; \
	fi

%.html:	%.mmd
	multimarkdown $*.mmd > $@

build:	$(MD_SRC:%.md=%.html) $(MMD_SRC:%.mmd=%.html)
#
# md-src: --markdown-specific customisations for the "src" target.
#
src:	md-src
.PHONY:	md-src
md-src:
	$(ECHO_TARGET)
	@mk-filelist -qn MD_SRC *.md
	@mk-filelist -qn MMD_SRC *.mmd

#
# todo: --Report unfinished work (identified by keyword comments)
#
.PHONY: md-todo
todo:	md-todo
md-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(MD_SRC) $(MMD_SRC) /dev/null || true
