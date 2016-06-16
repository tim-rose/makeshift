#
# Makefile --Build rules the make directory of devkit.
#
language = conf
CONF_SRC = subversion.conf tidy.conf
ETC_SRC = _astylerc _cvsignore _cvsrc _indent.pro _perltidyrc

include devkit.mk

$(sysconfdir)/%:	%;	$(INSTALL_FILE) $< $@
$(sysconfdir)/.%:	_%;	$(INSTALL_FILE) $< $@

install:		install-conf
install:		$(ETC_SRC:_%=$(sysconfdir)/.%)

uninstall:		uninstall-conf uninstall-etc
uninstall-etc:
	$(ECHO_TARGET)
	$(RM) $(ETC_SRC:_%=$(sysconfdir)/.%)
	$(RMDIR) -p $(sysconfdir) 2>/dev/null || true

toc:    toc-etc
toc-etc:
	mk-toc -t .sh $(ETC_SRC)

src:    toc-src
toc-src:
	@mk-filelist -n ETC_SRC _*
