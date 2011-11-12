#
# Makefile --Build rules the make directory of devkit.
#
LANG	= conf
MAKEFLAGS = -I ../make
CONF_SRC = subversion.conf tidy.conf
DOT_SRC = dot-astylerc dot-cvsignore dot-cvsrc dot-indent.pro \
    dot-perltidyrc

include devkit.mk

$(sysconfdir)/%:	%;	$(INSTALL_DATA) $< $@
$(sysconfdir)/.%:	dot-%;	$(INSTALL_DATA) $< $@

installdirs:		$(sysconfdir)
install:		$(CONF_SRC:%=$(sysconfdir)/%)
install:		$(DOT_SRC:dot-%=$(sysconfdir)/.%)

toc:
	mk-toc $(DOT_SRC)

src:
	mk-filelist -n DOT_SRC dot-*
