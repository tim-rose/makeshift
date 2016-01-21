#
# MARKDOWN.MK --Rules for dealing with markdown files.
#
# Contents:
# %.html/%.md:    --build a HTML document from a markdown file.
# %.pdf:          --Create a PDF document from a HTML file.
# build:          --Create HTML documents from MD_SRC, TXT_SRC.
# doc-markdown:   --Create PDF documents from MD_SRC, TXT_SRC.
# clean-markdown: --Clean up markdown's derived files.
# src-markdown:   --Update MD_SRC, TXT_SRC macros.
# todo-markdown:  --Report unfinished work in markdown files.
#
# Remarks:
# The markdown module recognises both "multimarkdow" markdown files
# (".md"), and simple text files (".txt"), defined by MD_SRC and
# TXT_SRC respectively. The markdown files are assumed to create full
# documents, and are created by `build`, using multimarkdown.
#
.PHONY: $(recursive-targets:%=%-markdown)

MD = multimarkdown
MDFLAGS ?= --process-html

MD_SRC ?= $(wildcard *.md)
TXT_SRC ?= $(wildcard *.txt)

TXT_CSS = $(exec_prefix)/share/doc/css/plain.css
PDF_CSS = $(exec_prefix)/share/doc/css/print.css

$(wwwdir)/%.html:	%.html;	$(INSTALL_FILE) $? $@

#
# %.html/%.md: --build a HTML document from a markdown file.
#
%.html:	%.md
	$(ECHO_TARGET)
	$(MD) $(MDFLAGS) $*.md > $@

#
# %.html/%.txt: build HTML document from a simple text file.
#
%.html:	%.txt
	$(ECHO_TARGET)
	{ echo "title: $*"; echo "css: file://$(TXT_CSS)"; echo; cat $*.txt; } |\
	    $(MD) $(MDFLAGS) > $@

#
# README.html: build HTML document from a README file.
#
# Remarks:
# Because github handles markdown specially, it's worth
# having a special rule for README.md files.
#
README.html:	README.md
	$(ECHO_TARGET)
	{ echo "title: README"; echo "css: file://$(TXT_CSS)"; echo; cat $<; } |\
	    $(MD) $(MDFLAGS) > $@
#
# %.pdf: --Create a PDF document from a HTML file.
#
%.pdf: %.html
	$(ECHO_TARGET)
	prince -s $(PDF_CSS) $*.html -o $@
#
# build: --Create HTML documents from MD_SRC, TXT_SRC.
#
build:	$(TXT_SRC:%.txt=%.html) $(MD_SRC:%.md=%.html)

#
# doc-markdown: --Create PDF documents from MD_SRC, TXT_SRC.
#
doc:	doc-markdown
doc-markdown:	$(TXT_SRC:%.txt=%.pdf) $(MD_SRC:%.md=%.pdf)

#
# clean-markdown: --Clean up markdown's derived files.
#
distclean:	clean-markdown
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
