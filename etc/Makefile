#
# Makefile --Build rules the make directory of devkit.
#
SRC_LANG	= conf
MAKEFLAGS = -I ../make
CONF_SRC = subversion.conf tidy.conf
ETC_SRC = _astylerc _cvsignore _cvsrc _indent.pro _perltidyrc

include devkit.mk

$(sysconfdir)/%:	%;	$(INSTALL_FILE) $< $@
$(sysconfdir)/.%:	_%;	$(INSTALL_FILE) $< $@

installdirs:		$(sysconfdir)
install:		$(CONF_SRC:%=$(sysconfdir)/%)
install:		$(ETC_SRC:_%=$(sysconfdir)/.%)

toc:
	mk-toc -t .sh $(ETC_SRC)

src:
	mk-filelist -n ETC_SRC _*
