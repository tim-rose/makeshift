#
# XSL.MK --Rules for building xsl scripts and libraries.
#
# Contents:
# %.xsl:         --Rules for installing xsl files
# install-xsl:   --Install XSL files and related include files.
# uninstall-xsl: --Remove XSL files and related include files.
# src-xsl:       --Update the XSL_SRC macro.
# todo:          --Report unfinished work in XSL files.
#
.PHONY: $(recursive-targets:%=%-xsl)

ifdef autosrc
    LOCAL_XSL_SRC := $(wildcard *.xsl)

    XSL_SRC ?= $(LOCAL_XSL_SRC)
endif

#
# %.xsl: --Rules for installing xsl files
#
xsllibdir = $(libdir)/xsl
install-xsl:	$(XSL_SRC:%.xsl=$(xsllibdir)/%.xsl)
$(xsllibdir)/%.xsl:	%.xsl;	$(INSTALL_DATA) $? $@

#
# install-xsl: --Install XSL files and related include files.
#
install-xsl:	$(XSL_SRC:%=$(xsllibdir)/%)

#
# uninstall-xsl: --Remove XSL files and related include files.
#
uninstall-xsl:
	$(ECHO_TARGET)
	$(RM) $(XSL_SRC:%=$(xsllibdir)/%)
	$(RMDIR) -p $(xsllibdir) 2>/dev/null ||:

#
# src-xsl: --Update the XSL_SRC macro.
#
src:	src-xsl
.PHONY:	src-xsl
src-xsl:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn XSL_SRC *.xsl

#
# todo: --Report unfinished work in XSL files.
#
.PHONY: todo-xsl
todo:	todo-xsl
todo-xsl:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(XSL_SRC)  /dev/null ||:
