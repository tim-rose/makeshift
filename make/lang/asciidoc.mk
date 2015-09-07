#
# ASCIIDOC.MK --Rules for building documents from asciidoc ".txt" files.
#
# Contents:
# %.xml:  --Rules for converting asciidoc ".txt" files into XML.
# %.fo:   --Rules for converting asciidoc ".txt" files into flow objects.
# %.html: --Rules for converting asciidoc ".xml" files into HTML
# %.pdf:  --Rules for converting asciidoc ".fo" files into PDF
# build:  --Build PDF and HTML documents from asciidoc files.
# src:    --Update the TXT_SRC macro with a list of asciidoc text files.
# clean:  --cleanup asciidoc intermediate files (.xml, .fo, .pdf)
# todo:   --Report unfinished work in asciidoc files.
#
# Remarks:
# The asciidoc module manages a list of simple asciidoc documents with
# the ".txt" extension, using the macro TXT_SRC.  It implements
# pattern rules for converting the ".txt" to docbook XML, and thence
# to flow objects (".fo"), PDF, and HTML output.  The build target
# will attempt to build both PDF and HTML.
#
.PHONY: $(recursive-targets:%=%-asciidoc)

#
# XSL_FLAGS is adapted from observing the output of a2x, and should
# be cleaned up.
# REVISIT: this needs to be generalised from hardcoded paths!
#
XSL_FLAGS = --stringparam callout.graphics 0 \
    --stringparam navig.graphics 0 \
    --stringparam admon.textlabel 1 \
    --stringparam admon.graphics 0
FO_XSL = /opt/local/etc/asciidoc/docbook-xsl/fo.xsl
HTML_XSL = /opt/local/etc/asciidoc/docbook-xsl/xhtml.xsl

#
# %.xml: --Rules for converting asciidoc ".txt" files into XML.
#
%.xml:  %.txt
	asciidoc --backend docbook --out-file "$@" "$*.txt"
	xmllint --nonet --noout --valid "$@"

#
# %.fo: --Rules for converting asciidoc ".txt" files into flow objects.
#
%.fo:	%.xml
	xsltproc $(XSL_FLAGS) --output "$*.fo" $(FO_XSL) "$*.xml"

#
# %.html: --Rules for converting asciidoc ".xml" files into HTML
#
%.html:	%.xml
	xsltproc $(XSL_FLAGS) --output "$*.html" $(HTML_XSL) "$*.xml"

#
# %.pdf: --Rules for converting asciidoc ".fo" files into PDF
#
%.pdf:	%.fo
	fop -fo "$*.fo" -pdf "$@"

#
# build: --Build PDF and HTML documents from asciidoc files.
#
build:	$(TXT_SRC:%.txt=%.pdf) $(TXT_SRC:%.txt=%.html)

#
# src: --Update the TXT_SRC macro with a list of asciidoc text files.
#
src:	src-asciidoc
src-asciidoc:
	$(ECHO_TARGET)
	@mk-filelist -qn TXT_SRC *.txt

#
# clean: --cleanup asciidoc intermediate files (.xml, .fo, .pdf)
#
clean:	clean-asciidoc
clean-asciidoc:
	$(RM) $(TXT_SRC:%.txt=%.xml) $(TXT_SRC:%.txt=%.fo) $(TXT_SRC:%.txt=%.pdf)

#
# todo: --Report unfinished work in asciidoc files.
#
todo:	todo-asciidoc
todo-asciidoc:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(ASCIIDOC_SRC)  /dev/null || true
