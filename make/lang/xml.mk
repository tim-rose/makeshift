#
# XML.MK --Rules for installing xml data.
#
# Contents:
# %.xml: --Rules for installing xml files
# src:   --Update the XML_SRC macro.
# todo:  --Report unfinished work in XML files.
#

.PHONY: $(recursive-targets:%=%-xml)

#
# %.xml: --Rules for installing xml files
#

$(sysconfdir)/%.xml:	%.xml;	$(INSTALL_FILE) $? $@
$(libdir)/%.xml:	%.xml;	$(INSTALL_FILE) $? $@

#
# src: --Update the XML_SRC macro.
#
src:	src-xml
src-xml:
	$(ECHO_TARGET)
	@mk-filelist -qn XML_SRC *.xml

#
# todo: --Report unfinished work in XML files.
#
todo:	xml-todo
xml-todo:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(XML_SRC)  /dev/null || true
