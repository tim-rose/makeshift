#
# MARKDOWN.MK --Rules for dealing with markdown files.
#
# Contents:
# README.html/README.md: --build a HTML document from a README file.
# %.html/%.md:         --build a HTML document from a markdown file.
# %.pdf:               --Create a PDF document from a HTML file.
# build:               --Create HTML documents from markdown.
# doc-markdown:        --Create PDF documents from MD_SRC.
# clean-markdown:      --Clean up markdown's derived files.
# src-markdown:        --Update MD_SRC, macros.
# todo-markdown:       --Report unfinished work in markdown files.
# +version:            --Report details of tools used by markdown.
#
# Remarks:
# This module also defines rules for building PDF files from HTML
# using prince(1).  It defines the following targets:
#
# * `doc-html` --build all the HTML documents from markdown sources
# * `doc-pdf`  --build all the PDF documents from markdown sources.
#
# The `doc` target depends on `doc-pdf`.
#
# The `src` target will update the makefile with the following macros:
#
# * MD_SRC --a list of the CommonMark/github-flavoured ".md" files
# * MMD_SRC --a list of the MultiMarkdown ".mmd" files
#
# The pandoc processing can be customised with the following variables:
# 
# * MD_STYLE --a list of HTML stylesheets
# * MD_FILTER --a list of pandoc filters
#
# See Also:
# http://alistapart.com/article/building-books-with-css3
# http://www.princexml.com/doc
#
.PHONY: $(recursive-targets:%=%-markdown)

PRINT_multimarkdown_VERSION = multimarkdown --version | sed -ne2p
PRINT_cmark-gfm_VERSION = cmark-gfm --version
PRINT_prince_VERSION = prince --version

ifdef autosrc
    LOCAL_MD_SRC := $(wildcard *.md)

    MD_SRC ?= $(LOCAL_MD_SRC)
endif

MD ?= pandoc
MD_STYLE ?= $(MAKESHIFT_HOME)/share/doc/css/plain.css

ALL_MDFLAGS ?= --to=html -f markdown-smart --standalone \
    $(MD_STYLE:%=--css=%) $(MD_FILTER:%=--filter=%)\
    $(OS.MDFLAGS) $(ARCH.MDFLAGS) $(PROJECT.MDFLAGS) \
    $(LOCAL.MDFLAGS) $(TARGET.MDFLAGS) $(MDFLAGS)

HTML_PDF ?= prince
ALL_HTML_PDFFLAGS ?= $(OS.HTML_PDFFLAGS) $(ARCH.HTML_PDFFLAGS) \
    $(PROJECT.HTML_PDFFLAGS) $(LOCAL.HTML_PDFFLAGS) $(TARGET.HTML_PDFFLAGS) $(HTML_PDFFLAGS)

#
# Rules to install HTML files (@revisit: should go in html.mk?)
#
$(wwwdir)/%.html:	%.html;	$(INSTALL_DATA) $? $@
$(datadir)/%.html:	%.html; $(INSTALL_DATA) $? $@

#
# README.html/README.md: --build a HTML document from a README file.
#
# Remarks:
# README files are processed as github-flavoured markdown.
#
README.html:	README.md
	$(ECHO_TARGET)
	$(MD) --from gfm $(ALL_MDFLAGS) README.md > $@
#

#
# %.html/%.md: --build a HTML document from a markdown file.
#
%.html:	%.md | $(gendir)
	$(ECHO_TARGET)
	printf "version: "$(VERSION)"\n" > $(gendir)/version.yaml
	$(MD) --metadata-file $(gendir)/version.yaml $(ALL_MDFLAGS) $*.md > $@
	$(RM) $(gendir)/version.yaml
#
# %.pdf: --Create a PDF document from a HTML file.
# @todo: allow for alternate PDF engines
%.pdf: %.html
	$(ECHO_TARGET)
	$(HTML_PDF) -s $(MAKESHIFT_HOME)/share/doc/css/print.css --javascript $*.html -o $@

#
# build: --Create HTML documents from markdown.
#
doc-html:	$(MD_SRC:%.md=%.html)

#
# doc-markdown: --Create PDF documents from MD_SRC.
#
doc-pdf doc:	doc-markdown
doc-markdown:	$(MD_SRC:%.md=%.pdf)

#
# clean-markdown: --Clean up markdown's derived files.
#
distclean:	clean-markdown
clean:	clean-markdown
clean-markdown:
	$(ECHO_TARGET)
	$(RM) $(MD_SRC:%.md=%.html) $(MD_SRC:%.md=%.pdf) $(MD_SRC:%.md=$(gendir)/%.md)

#
# src-markdown: --Update MD_SRC, macros.
#
src:	src-markdown
src-markdown:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qn MD_SRC *.md

#
# todo-markdown: --Report unfinished work in markdown files.
#
todo:	todo-markdown
todo-markdown:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(MD_SRC) /dev/null ||:
#
# +version: --Report details of tools used by markdown.
#
+version: cmd-version[$(MD)] cmd-version[$(HTML_PDF)]
