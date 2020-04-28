#
# MARKDOWN.MK --Rules for dealing with markdown files.
#
# Contents:
# %.html/%.md:    --build a HTML document from a markdown file.
# %.pdf:          --Create a PDF document from a HTML file.
# build:          --Create HTML documents from markdown.
# doc-markdown:   --Create PDF documents from MMD_SRC, MD_SRC.
# clean-markdown: --Clean up markdown's derived files.
# src-markdown:   --Update MD_SRC, MMD_SRC macros.
# todo-markdown:  --Report unfinished work in markdown files.
# +version:       --Report details of tools used by markdown.
#
# Remarks:
# The markdown module recognises both "multimarkdown" markdown files
# (".mmd"), and simple markdown files (".md"), defined by MMD_SRC and
# MD_SRC respectively.  Use `make src` to update these macros.
#
# Simple markdown is assumed to be Github-flavoured, and uses the
# `cmark-gfm` processor by default to generate the HTML. `cmark-gfm`
# generates a HTML fragment only, so the build rule adds some
# prologue, epilogue to form a complete HTML document.  The prologue
# assumes that highlightjs is installed, and uses it for syntax
# highlighting.
#
# For Multimarkdown (.mmd) files, the metadata is assumed to contain
# appropriate CSS and JS to achieve the author's intent, and the
# "--full" option is used to generate a complete HTML document.
#
# This module also defines rules for building PDF files from HTML using prince(1).
# It defines the following targets:
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
    LOCAL_MMD_SRC := $(wildcard *.mmd)

    MD_SRC ?= $(LOCAL_MD_SRC)
    MMD_SRC ?= $(LOCAL_MMD_SRC)
endif

MD ?= cmark-gfm
ALL_MDFLAGS ?= --unsafe --smart --extension table --extension footnotes \
    $(OS.MDFLAGS) $(ARCH.MDFLAGS) $(PROJECT.MDFLAGS) \
    $(LOCAL.MDFLAGS) $(TARGET.MDFLAGS) $(MDFLAGS)

MD_PROLOGUE = $(DEVKIT_HOME)/share/doc/cmark-prologue.txt
MD_EPILOGUE = $(DEVKIT_HOME)/share/doc/cmark-epilogue.txt

MMD ?= multimarkdown
ALL_MMDFLAGS ?= --full $(OS.MMDFLAGS) $(ARCH.MMDFLAGS) $(PROJECT.MMDFLAGS) \
    $(LOCAL.MMDFLAGS) $(TARGET.MMDFLAGS) $(MMDFLAGS)

HTML_PDF ?= prince
ALL_HTML_PDFFLAGS ?= $(OS.HTML_PDFFLAGS) $(ARCH.HTML_PDFFLAGS) \
    $(PROJECT.HTML_PDFFLAGS) $(LOCAL.HTML_PDFFLAGS) $(TARGET.HTML_PDFFLAGS) $(HTML_PDFFLAGS)

#
# Rules to install HTML files (@revisit: should go in html.mk?)
#
$(wwwdir)/%.html:	%.html;	$(INSTALL_DATA) $? $@
$(datadir)/%.html:	%.html; $(INSTALL_DATA) $? $@

#
# %.html/%.md: --build a HTML document from a markdown file.
#
%.html:	%.md
	$(ECHO_TARGET)
	sed -e 's|<title>.*|<title>$*</title>|' $(MD_PROLOGUE) >$@
	$(MD) $(ALL_MDFLAGS) $*.md >> $@
	cat $(MD_EPILOGUE) >> $@

%.html:	$(gendir)/%.md
	$(ECHO_TARGET)
	sed -e 's|<title>.*|<title>$*</title>|' $(MD_PROLOGUE) >$@
	$(MD) $(ALL_MDFLAGS) $(gendir)/$*.md >> $@
	cat $(MD_EPILOGUE) >> $@

%.html:	%.mmd
	$(ECHO_TARGET)
	$(MMD) $(ALL_MMDFLAGS) $*.mmd > $@

%.html:	$(gendir)/%.mmd
	$(ECHO_TARGET)
	$(MMD) $(ALL_MMDFLAGS) $(gendir)/$*.mmd > $@

#
# %.pdf: --Create a PDF document from a HTML file.
# @todo: allow for alternate PDF engines
%.pdf: %.html
	$(ECHO_TARGET)
	$(HTML_PDF) --javascript $*.html -o $@

#
# build: --Create HTML documents from markdown.
#
doc-html:	$(MMD_SRC:%.mmd=%.html) $(MD_SRC:%.md=%.html)

#
# doc-markdown: --Create PDF documents from MMD_SRC, MD_SRC.
#
doc-pdf doc:	doc-markdown
doc-markdown:	$(MMD_SRC:%.mmd=%.pdf) $(MD_SRC:%.md=%.pdf)

#
# clean-markdown: --Clean up markdown's derived files.
#
distclean:	clean-markdown
clean:	clean-markdown
clean-markdown:
	$(ECHO_TARGET)
	$(RM) $(MMD_SRC:%.mmd=%.html) $(MD_SRC:%.md=%.html) $(MMD_SRC:%.mmd=%.pdf) $(MD_SRC:%.md=%.pdf) $(MMD_SRC:%.mmd=$(gendir)/%.mmd) $(MD_SRC:%.md=$(gendir)/%.md)

#
# src-markdown: --Update MD_SRC, MMD_SRC macros.
#
src:	src-markdown
src-markdown:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qn MMD_SRC *.mmd
	$(Q)mk-filelist -f $(MAKEFILE) -qn MD_SRC *.md

#
# todo-markdown: --Report unfinished work in markdown files.
#
todo:	todo-markdown
todo-markdown:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(MD_SRC) $(MMD_SRC) /dev/null ||:
#
# +version: --Report details of tools used by markdown.
#
+version: cmd-version[$(MD)] cmd-version[$(MMD)] cmd-version[$(HTML_PDF)]
