#
# MARKDOWN.MK --Rules for dealing with markdown files.
#
# Contents:
# %.html/%.md:    --build a HTML document from a markdown file.
# %.pdf:          --Create a PDF document from a HTML file.
# build:          --Create HTML documents from markdown.
# doc-markdown:   --Create PDF documents from TXT_SRC, MD_SRC.
# clean-markdown: --Clean up markdown's derived files.
# src-markdown:   --Update MD_SRC, TXT_SRC macros.
# todo-markdown:  --Report unfinished work in markdown files.
#
# Remarks:
# The markdown module recognises both "multimarkdown" markdown files
# (".mmd"), and simple markdown files (".md"), defined by MMD_SRC and
# MD_SRC respectively.
#
# @todo: use cmark for ".md", and multimarkdown for ".mmd"
# @todo: create cmark prologue/epilogue for creating full documents
#
# See Also:
# http://alistapart.com/article/building-books-with-css3
# http://www.princexml.com/doc
#
.PHONY: $(recursive-targets:%=%-markdown)

MD ?= cmark-gfm
ALL_MDFLAGS ?= --unsafe --smart --extension table --extension footnotes \
    $(OS.MDFLAGS) $(ARCH.MDFLAGS) $(PROJECT.MDFLAGS) \
    $(LOCAL.MDFLAGS) $(TARGET.MDFLAGS) $(MDFLAGS)
MMD ?= multimarkdown
ALL_MMDFLAGS ?= -f $(OS.MMDFLAGS) $(ARCH.MMDFLAGS) $(PROJECT.MMDFLAGS) \
    $(LOCAL.MMDFLAGS) $(TARGET.MMDFLAGS) $(MMDFLAGS)

HTML_PDF ?= prince
ALL_HTML_PDFFLAGS ?= $(OS.HTML_PDFFLAGS) $(ARCH.HTML_PDFFLAGS) \
    $(PROJECT.HTML_PDFFLAGS) $(LOCAL.HTML_PDFFLAGS) $(TARGET.HTML_PDFFLAGS) $(HTML_PDFFLAGS)

ifdef autosrc
    LOCAL_MD_SRC := $(wildcard *.md)
    LOCAL_MMD_SRC := $(wildcard *.mmd)

    MD_SRC ?= $(LOCAL_MD_SRC)
    MMD_SRC ?= $(LOCAL_MMD_SRC)
endif

MMD_CSS ?= $(DEVKIT_HOME)/share/doc/css/plain.css
PDF_CSS ?= $(DEVKIT_HOME)/share/doc/css/print.css
MD_PROLOGUE = $(DEVKIT_HOME)/share/doc/cmark-prologue.txt
MD_EPILOGUE = $(DEVKIT_HOME)/share/doc/cmark-epilogue.txt

$(wwwdir)/%.html:	%.html;	$(INSTALL_DATA) $? $@
$(datadir)/%.html:	%.html; $(INSTALL_DATA) $? $@

#
# %.html/%.md: --build a HTML document from a markdown file.
#
%.html:	%.md | $(archdir)
	$(ECHO_TARGET)
	cat $(MD_PROLOGUE) >$@
	$(MD) $(ALL_MDFLAGS) $*.md >> $@
	cat $(MD_EPILOGUE) >> $@

%.html:	%.mmd
	$(ECHO_TARGET)
	$(MMD) $(ALL_MMDFLAGS) $*.mmd > $@

%.html:	$(gendir)/%.md | $(gendir)
	$(ECHO_TARGET)
	$(MD) $(ALL_MDFLAGS) $(gendir)/$*.md > $@


#
# %.pdf: --Create a PDF document from a HTML file.
#
%.pdf: %.html
	$(ECHO_TARGET)
	prince -s $(PDF_CSS) $*.html -o $@

#
# build: --Create HTML documents from markdown.
#
doc-html:	$(MMD_SRC:%.mmd=%.html) $(MD_SRC:%.md=%.html)

#
# doc-markdown: --Create PDF documents from TXT_SRC, MD_SRC.
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
	$(RM) $(MMD_SRC:%.mmd=%.html) $(MD_SRC:%.md=%.html) \
            $(MMD_SRC:%.mmd=%.pdf) $(MD_SRC:%.md=%.pdf) \
            $(MMD_SRC:%.mmd=$(gendir)/%.md) $(MD_SRC:%.md=$(gendir)/%.md)

#
# src-markdown: --Update MD_SRC, TXT_SRC macros.
#
src:	src-markdown
src-markdown:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn MMD_SRC *.mmd
	@mk-filelist -f $(MAKEFILE) -qn MD_SRC *.md

#
# todo-markdown: --Report unfinished work in markdown files.
#
todo:	todo-markdown
todo-markdown:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(MD_SRC) $(MMD_SRC) /dev/null || true
