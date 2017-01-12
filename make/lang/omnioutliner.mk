#
# OMNIOUTLINER.MK --Rules for dealing with omnioutliner files.
#
# Contents:
# %.html/%.md:        --build a HTML document from a mulitomnioutliner file.
# build:              --Create HTML documents from OO_SRC.
# clean-omnioutliner: --Clean up omnioutliner's derived files.
# src-omnioutliner:   --Update OO_SRC.
# todo-omnioutliner:  --Report unfinished work in omnioutliner files.
#
# Remarks:

# Omnioutliner stores outlines as <name>.oo3/content.xml.  The actual
# file content is usually compressed.  This module contains rules for converting
# the XML into markdown, for subsequent processing.
#
# @todo: write a "boom!" format processor...
#
# See Also:
# http://omnigroup.com
#
.PHONY: $(recursive-targets:%=%-omnioutliner)

ifdef autosrc
    LOCAL_OO_SRC := $(wildcard *.oo3)

    OO_SRC ?= $(LOCAL_OO_SRC)
endif

OO_MD_XSL = $(libdir)/xsl/oo-md.xsl

#
# %.html/%.md: --build a HTML document from a mulitomnioutliner file.
#
$(archdir)/gen/%.txt:	%.oo3
	$(ECHO_TARGET)
	$(MKDIR) $(archdir)/gen
	gzcat -cf $*.oo3/contents.xml $*.oo3/contents.xml | \
            xsltproc $(OOFLAGS) $(OO_MD_XSL) - > $@

#
# build: --Create HTML documents from OO_SRC.
#
build:	build-omnioutliner
build-omnioutliner:	$(OO_SRC:%.oo3=$(archdir)/gen/%.txt)

doc: doc-omnioutliner
doc-omnioutliner:	$(OO_SRC:%.oo3=%.pdf)

#
# clean-omnioutliner: --Clean up omnioutliner's derived files.
#
distclean:	clean-omnioutliner
clean:	clean-omnioutliner
clean-omnioutliner:
	$(ECHO_TARGET)
	$(RM) $(OO_SRC:%.oo3=$(archdir)/%.txt) $(OO_SRC:%.oo3=%.html) $(OO_SRC:%.oo3=%.pdf)

#
# src-omnioutliner: --Update OO_SRC.
#
src:	src-omnioutliner
src-omnioutliner:
	$(ECHO_TARGET)
	@mk-filelist -qdn OO_SRC *.oo3

#
# todo-omnioutliner: --Report unfinished work in omnioutliner files.
#
todo:	todo-omnioutliner
todo-omnioutliner:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(OO_SRC:%=%/contents.xml) $(TXT_SRC) /dev/null || true
