#
# XSL.MK --Rules for building xsl scripts and libraries.
#
# %.xsl: --Rules for installing xsl files
#
$(libdir)/%.xsl:	%.xsl;	$(INSTALL_FILE) $? $@

#
# xsl-src: --xsl-specific customisations for the "src" target.
#
src:	xsl-src
.PHONY:	xsl-src
xsl-src:
	$(ECHO_TARGET)
	@mk-filelist -qn XSL_SRC *.xsl

#
# todo: --Report unfinished work (identified by keyword comments)
#
.PHONY: xsl-todo
todo:	xsl-todo
xsl-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(XSL_SRC)  /dev/null || true
