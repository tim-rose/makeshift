#
# XML.MK --Rules for installing xml data.
#
# %.xml: --Rules for installing xml files
#
$(sysconfdir)/%.xml:	%.xml;	$(INSTALL_FILE) $? $@
$(libdir)/%.xml:	%.xml;	$(INSTALL_FILE) $? $@

#
# xml-src: --xml-specific customisations for the "src" target.
#
src:	xml-src
.PHONY:	xml-src
xml-src:
	$(ECHO_TARGET)
	@mk-filelist -qn XML_SRC *.xml

#
# todo: --Report unfinished work (identified by keyword comments)
#
.PHONY: xml-todo
todo:	xml-todo
xml-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(XML_SRC)  /dev/null || true
