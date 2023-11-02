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
MD_STYLE ?= $(makeshift_sharedir)/doc/css/plain.css

ALL_MDFLAGS ?= -f markdown-smart \
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
	$(MD) --from gfm --to=html $(ALL_MDFLAGS) README.md > $@ || $(RM) $@
#

#
# %.html/%.md: --build a HTML document from a markdown file.
#
# Remarks:
# Note that we build the metadata file each time, rather than make it
# at the start and remove it at the end.  If we did that, it would
# force a rebuild every time.  Hmmmm.
#
%.html:	%.md | $(gendir)
	$(ECHO_TARGET)
	printf "version: "$(VERSION)"\n" > $(gendir)/version.yaml
	$(MD) --metadata-file $(gendir)/version.yaml --to=html --standalone \
	    $(ALL_MDFLAGS) $*.md > $@ || $(RM) $@
	$(RM) $(gendir)/version.yaml
%.html:	%.rst | $(gendir)
	$(ECHO_TARGET)
	$(MD) --from=rst --to=html --standalone \
	    $(ALL_MDFLAGS) $*.rst > $@ || $(RM) $@
#
# %.pdf: --Create a PDF document from a HTML file.
# @todo: allow for alternate PDF engines
%.pdf: %.html
	$(ECHO_TARGET)
	$(HTML_PDF) -s $(makeshift_sharedir)/doc/css/print.css --javascript $*.html -o $@

#
# build: --Create HTML documents from markdown.
#
doc-html:	$(MD_SRC:%.md=%.html) $(RST_SRC:%.rst=%.html)

#
# doc-markdown: --Create PDF documents from MD_SRC.
#
doc-pdf doc:	doc-markdown doc-rst
doc-markdown:	$(MD_SRC:%.md=%.pdf)
doc-rst:	$(RST_SRC:%.md=%.pdf)

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
	$(Q)mk-filelist -f $(MAKEFILE) -qn RST_SRC *.rst

#
# todo-markdown: --Report unfinished work in markdown files.
#
todo:	todo-markdown
todo-markdown:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(MD_SRC) $(RST_SRC) /dev/null ||:
#
# +version: --Report details of tools used by markdown.
#
+version: cmd-version[$(MD)] cmd-version[$(HTML_PDF)]
