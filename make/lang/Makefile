#
# Makefile --Build rules for the lang directory of devkit.
#
MAKEFLAGS=-I..
MK_SRC = c++.mk c.mk conf.mk css.mk html.mk img.mk java.mk \
    javascript.mk lex.mk lisp.mk mk.mk nroff.mk perl.mk php.mk \
    python.mk ruby.mk sh.mk sql.mk template.mk xml.mk xsl.mk \
    yacc.mk
subdir	= lang

include devkit.mk 

$(includedir)/%:	%;		$(INSTALL_FILE) $< $@

install:		$(MK_SRC:%=$(includedir)/%)

