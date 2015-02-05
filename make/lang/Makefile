#
# Makefile --Build rules for the lang directory of devkit.
#
MK_SRC = asciidoc.mk c++.mk c.mk conf.mk css.mk elisp.mk img.mk \
    java.mk javascript.mk lex.mk markdown.mk mk.mk nroff.mk \
    perl.mk php.mk python.mk qt.mk ruby.mk sh.mk sql.mk tex.mk \
    xml.mk xsd.mk xsl.mk yacc.mk
subdir	= lang

include devkit.mk

$(includedir)/%:	%;		$(INSTALL_FILE) $< $@

install:		$(MK_SRC:%=$(includedir)/%)

