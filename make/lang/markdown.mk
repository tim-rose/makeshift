#
# MARKDOWN.MK --Rules for dealing with markdown files.
#
# Contents:
# build: --Create HTML documents from MMD_SRC.
# clean: --Clean up MMD_SRC derived files.
# src:   --Update MD_SRC, MMD_SRC macros.
# todo:  --Report unfinished work in markdown files.
#
# Remarks:
# The markdown module recognises both "original" markdown files
# (".md"), and "multimarkdown" files (".mmd"), defined by MD_SRC and
# MMD_SRC respectively. MMD files are assumed to create full
# documents, and are created by `build`, using multimarkdown. There
# are pattern rules for converting MD src to HTML, but markdown
# doesn't create a full HTML document, and they aren't built by
# default.
#

$(wwwdir)/%.html:	%.html;	$(INSTALL_FILE) $? $@

%.html:	%.md
	$(ECHO_TARGET)
	markdown $*.md >$@
%.html:	%.mmd
	$(ECHO_TARGET)
	multimarkdown $*.mmd > $@

#
# build: --Create HTML documents from MMD_SRC.
#
build:	$(MMD_SRC:%.mmd=%.html) cmd-exists[multimarkdown]

#
# clean: --Clean up MMD_SRC derived files.
#
clean:	clean-markdown
.PHONY:	clean-markdown
clean-markdown:
	$(ECHO_TARGET)
	$(RM) $(MMD_SRC:%.mmd=%.html) $(MD_SRC:%.md=%.html)


#
# src: --Update MD_SRC, MMD_SRC macros.
#
src:	src-markdown
.PHONY:	src-markdown
src-markdown:
	$(ECHO_TARGET)
	@mk-filelist -qn MD_SRC *.md
	@mk-filelist -qn MMD_SRC *.mmd

#
# todo: --Report unfinished work in markdown files.
#
todo:	todo-markdown
.PHONY: todo-markdown
todo-markdown:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(MD_SRC) $(MMD_SRC) /dev/null || true
