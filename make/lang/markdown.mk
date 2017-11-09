#
# MARKDOWN.MK --Rules for dealing with markdown files.
#
# Contents:
# %.html/%.md:    --build a HTML document from a mulitmarkdown file.
# %.txt/%.md:     --Create a full (multi)markdown file from a simple text file.
# %.pdf:          --Create a PDF document from a HTML file.
# build:          --Create HTML documents from TXT_SRC, MD_SRC.
# doc-markdown:   --Create PDF documents from TXT_SRC, MD_SRC.
# clean-markdown: --Clean up markdown's derived files.
# src-markdown:   --Update MD_SRC, TXT_SRC macros.
# todo-markdown:  --Report unfinished work in markdown files.
#
# Remarks:
# The markdown module recognises both "multimarkdown" markdown files
# (".md"), and simple markdown/text files (".txt"), defined by MD_SRC and
# TXT_SRC respectively. The markdown files are assumed to create full
# documents, and are created by `build`, using multimarkdown.
#
# @todo: support other formats (latex etc.)
#
# See Also:
# http://alistapart.com/article/building-books-with-css3
# http://www.princexml.com/doc
#
.PHONY: $(recursive-targets:%=%-markdown)

MD ?= multimarkdown
ALL_MDFLAGS ?= --process-html $(OS.MDFLAGS) $(ARCH.MDFLAGS) \
    $(PROJECT.MDFLAGS) $(LOCAL.MDFLAGS) $(TARGET.MDFLAGS) $(MDFLAGS)

MD_FILTER ?= cat

HTML_PDF ?= prince
ALL_HTML_PDFFLAGS ?= --process-html $(OS.HTML_PDFFLAGS) $(ARCH.HTML_PDFFLAGS) \
    $(PROJECT.HTML_PDFFLAGS) $(LOCAL.HTML_PDFFLAGS) $(TARGET.HTML_PDFFLAGS) $(HTML_PDFFLAGS)

ifdef autosrc
    LOCAL_TXT_SRC := $(wildcard *txt)
    LOCAL_MD_SRC := $(wildcard *.md)

    TXT_SRC ?= $(LOCAL_TXT_SRC)
    MD_SRC ?= $(LOCAL_MD_SRC)
endif

#
# Include any dependency information that's available.
#
-include $(MD_SRC:%.md=$(archdir)/%.d)

MMD_CSS ?= $(DEVKIT_HOME)/share/doc/css/plain.css
PDF_CSS ?= $(DEVKIT_HOME)/share/doc/css/print.css

$(wwwdir)/%.html:	%.html;	$(INSTALL_DATA) $? $@
$(datadir)/%.html:	%.html; $(INSTALL_DATA) $? $@

#
# %.html/%.md: --build a HTML document from a mulitmarkdown file.
#
# Remarks:
# This rule creates a (simplistic) dependency file too.
#
%.html:	%.md | $(archdir)
	$(ECHO_TARGET)
	$(MD) $(ALL_MDFLAGS) $*.md | $(MD_FILTER) > $@
	sed -ne '/css:/s|css: *\(file://\)*|$@: |p' $*.md > $(archdir)/$*.d

%.html:	$(gendir)/%.md
	$(ECHO_TARGET)
	$(MD) $(ALL_MDFLAGS) $(gendir)/$*.md > $@
	sed -ne '/css:/s|css: *\(file://\)*|$@: |p' $(gendir)/$*.md  > $(archdir)/$*.d

#
# README.html --Special handling for generating README doc.s
#
README.html:	$(gendir)/README.md
	$(ECHO_TARGET)
	$(MD) $(ALL_MDFLAGS) $(gendir)/README.md | $(MD_FILTER) > $@
	sed -ne '/css:/s|css: *\(file://\)*|$@: |p' $(gendir)/README.md > $(archdir)/README.d

#
# %.txt/%.md: --Create a full (multi)markdown file from a simple text file.
#
$(gendir)/%.md: %.txt | $(gendir)
	$(ECHO_TARGET)
	printf "title: $*\ncss: %s\n\n" "$(MMD_CSS)" > $@
	cat $*.txt >> $@

#
# README.md --Special rules for handling README markdown files.
#
# Remarks:
# README.md files tend to be github format markdown, which is
# a little simpler than multimarkdown, and in particular lacks
# a header block.  This rule generates the header block with
# some basic CSS styling.
#
$(gendir)/README.md: README.md | $(gendir)
	$(ECHO_TARGET)
	printf "title: README\ncss: %s\n\n" "$(MMD_CSS)" > $@
	cat README.md >> $@

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
build-markdown:	$(TXT_SRC:%.txt=%.html) $(MD_SRC:%.md=%.html)

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
	$(RM) $(TXT_SRC:%.txt=%.html) $(MD_SRC:%.md=%.html) $(TXT_SRC:%.txt=%.pdf) $(MD_SRC:%.md=%.pdf) $(TXT_SRC:%.txt=$(archdir)/%.d) $(MD_SRC:%.md=$(archdir)/%.d) $(TXT_SRC:%.txt=$(genhdir)/%.md)

#
# src-markdown: --Update MD_SRC, TXT_SRC macros.
#
src:	src-markdown
src-markdown:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn TXT_SRC *.txt
	@mk-filelist -f $(MAKEFILE) -qn MD_SRC *.md

#
# todo-markdown: --Report unfinished work in markdown files.
#
todo:	todo-markdown
todo-markdown:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(MD_SRC) $(TXT_SRC) /dev/null || true
