#
# OMNIOUTLINER.MK --Rules for dealing with omnioutliner files.
#
# Contents:
#
# Remarks:
# Omnioutliner stores outlines as <name>.oo3/content.xml.  The actual file content is usually compressed
#
#

# I use omnioutliner to write document drafts that are then converted to
# markdown.  These rules convert the OO XML files into markdown text using
# Fletcher Penney's excellent XSL.
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
	if [ "$$(head -c 5 $*.oo3/contents.xml)" != "<?xml" ]; then gzcat $*.oo3/contents.xml; else cat $*.oo3/contents.xml; fi |	xsltproc $(OOFLAGS) $(OO_MD_XSL) - > $@

#
# build: --Create HTML documents from TXT_SRC, OO_SRC.
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
