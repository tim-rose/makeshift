subdir = doc

include makeshift.mk

install: $(TXT_SRC:%=$(datadir)/%)
uninstall: uninstall-local
uninstall-local:
	$(RM) $(TXT_SRC:%=$(datadir)/%)
	$(RMDIR) -p $(datadir) 2>/dev/null || true

src: src-local
src-local:
	mk-filelist -n TXT_SRC *.txt

