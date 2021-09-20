#
# Makefile --Build rules the make directory of makeshift.
#
subdir = local
TXT_SRC = misra.txt

include makeshift.mk

$(sysconfdir)/%:	%;	$(INSTALL_DATA) $< $@
$(sysconfdir)/.%:	_%;	$(INSTALL_DATA) $< $@

install: $(TXT_SRC:%=$(datadir)/%)

uninstall:		uninstall-local 
uninstall-local:
	$(ECHO_TARGET)
	$(RM) $(TXT_SRC:%=$(datadir)/%)
	$(RMDIR) -p $(datadir) 2>/dev/null || true

src: src-local
src-local:
	mk-filelist -n TXT_SRC *.txt

