#
# MARKDOWN.MK --Rules for dealing with markdown files.
#
# Contents:
# %.html/%.md:    --build a HTML document from a mulitmarkdown file.
# %.pdf:          --Create a PDF document from a HTML file.
# build:          --Create HTML documents from TXT_SRC, MD_SRC.
# doc-markdown:   --Create PDF documents from TXT_SRC, MD_SRC.
# clean-markdown: --Clean up markdown's derived files.
# src-markdown:   --Update MD_SRC, TXT_SRC macros.
# todo-markdown:  --Report unfinished work in markdown files.
#
# Remarks:
# The markdown module recognises both "multimarkdown" markdown files
# ("txt"), and simple markdown/text files (".md"), defined by TXT_SRC and
# MD_SRC respectively. The markdown files are assumed to create full
# documents, and are created by `build`, using multimarkdown.
#
# See Also:
# http://alistapart.com/article/building-books-with-css3
# http://www.princexml.com/doc
#
.PHONY: $(recursive-targets:%=%-markdown)

MD = multimarkdown
MDFLAGS ?= --process-html

ifdef AUTOSRC
    LOCAL_TXT_SRC := $(wildcard *txt)
    LOCAL_MD_SRC := $(wildcard *.md)

    TXT_SRC ?= $(LOCAL_TXT_SRC)
    MD_SRC ?= $(LOCAL_MD_SRC)
endif

MMD_CSS ?= $(DEVKIT_HOME)/share/doc/css/plain.css
PDF_CSS ?= $(DEVKIT_HOME)/share/doc/css/print.css

$(wwwdir)/%.html:	%.html;	$(INSTALL_DATA) $? $@
$(datadir)/%.html:	%.html; $(INSTALL_DATA) $? $@

#
# %.html/%.md: --build a HTML document from a mulitmarkdown file.
#
%.html:	%.txt
	$(ECHO_TARGET)
	$(MD) $(MDFLAGS) $*.txt > $@

#
# %.html/%.md: build HTML document from a simple markdown file.
#
%.html:	%.md
	$(ECHO_TARGET)
	{ echo "title: $*"; \
          echo "css: file://$(MMD_CSS)"; \
          echo; cat $*.md; } | $(MD) $(MDFLAGS) > $@

#
# %.pdf: --Create a PDF document from a HTML file.
#
%.pdf: %.html
	$(ECHO_TARGET)
	prince -s $(PDF_CSS) $*.html -o $@
#
# build: --Create HTML documents from TXT_SRC, MD_SRC.
#
build:	build-markdown
build-mardkown:	$(TXT_SRC:%.txt=%.html) $(MD_SRC:%.md=%.html)

#
# doc-markdown: --Create PDF documents from TXT_SRC, MD_SRC.
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
	@mk-filelist -qn TXT_SRC *.txt
	@mk-filelist -qn MD_SRC *.md

#
# todo-markdown: --Report unfinished work in markdown files.
#
todo:	todo-markdown
todo-markdown:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(MD_SRC) $(TXT_SRC) /dev/null || true
