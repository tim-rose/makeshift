#
# MARKDOWN.MK --Rules for dealing with markdown files.
#
# Contents:
# %.html:         --build a HTML document from a markdown file.
# %.pdf:          --Create a PDF document from a HTML file.
# build:          --Create HTML documents from MMD_SRC.
# doc-markdown:   --Create PDF documents.
# clean-markdown: --Clean up markdown's derived files.
# src-markdown:   --Update MD_SRC, TXT_SRC macros.
# todo-markdown:  --Report unfinished work in markdown files.
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
.PHONY: $(recursive-targets:%=%-markdown)

MD = multimarkdown
MDFLAGS ?= --process-html

$(wwwdir)/%.html:	%.html;	$(INSTALL_FILE) $? $@

#
# %.html: --build a HTML document from a markdown file.
#
%.html:	%.md
	$(ECHO_TARGET)
	$(MD) $(MDFLAGS) $*.md > $@

#
# TODO: build HTML document from simple text file (i.e. with no mmd headers).
#
# %.html:	%.txt
# 	$(ECHO_TARGET)
# 	$(MD) $(MDFLAGS) $*.txt > $@

#
# %.pdf: --Create a PDF document from a HTML file.
#
%.pdf: %.html
	$(ECHO_TARGET)
	prince -s /usr/local/share/doc/css/print.css $*.html -o $@
#
# build: --Create HTML documents from MMD_SRC.
#
build:	$(TXT_SRC:%.txt=%.html) $(MD_SRC:%.md=%.html)

#
# doc-markdown: --Create PDF documents.
#
doc:	doc-markdown
doc-markdown:	$(TXT_SRC:%.txt=%.pdf) $(MD_SRC:%.md=%.pdf)

#
# clean-markdown: --Clean up markdown's derived files.
#
clean:	clean-markdown
clean-markdown:
	$(ECHO_TARGET)
	$(RM) $(TXT_SRC:%.txt=%.html) $(MD_SRC:%.md=%.html) $(TXT_SRC:%.txt=%.pdf) $(MD_SRC:%.md=%.pdf)


#
# src-markdown: --Update MD_SRC, TXT_SRC macros.
#
src:	src-markdown
src-markdown:
	$(ECHO_TARGET)
	@mk-filelist -qn MD_SRC *.md
	@mk-filelist -qn TXT_SRC *.txt

#
# todo-markdown: --Report unfinished work in markdown files.
#
todo:	todo-markdown
todo-markdown:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(MD_SRC) $(TXT_SRC) /dev/null || true
