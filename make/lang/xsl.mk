#
# XSL.MK --Rules for building xsl scripts and libraries.
#
# Contents:
# %.xsl:   --Rules for installing xsl files
# src-xsl: --Update the XSL_SRC macro.
# todo:    --Report unfinished work in XSL files.
#
.PHONY: $(recursive-targets:%=%-xsl)

#
# %.xsl: --Rules for installing xsl files
#
$(libdir)/%.xsl:	%.xsl;	$(INSTALL_FILE) $? $@

#
# src-xsl: --Update the XSL_SRC macro.
#
src:	src-xsl
.PHONY:	src-xsl
src-xsl:
	$(ECHO_TARGET)
	@mk-filelist -qn XSL_SRC *.xsl

#
# todo: --Report unfinished work in XSL files.
#
.PHONY: todo-xsl
todo:	todo-xsl
todo-xsl:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(XSL_SRC)  /dev/null || true
