#
# Makefile --build rules for installing the support files for markdown.
#
language = css
subdir = doc/css
CSS_SRC = numbered.css plain.css print.css
include makeshift.mk

install:	$(CSS_SRC:%=$(datadir)/%)
uninstall:	uninstall-local
uninstall-local:
	$(ECHO_TARGET)
	$(RM) $(CSS_SRC:%=$(datadir)/%)
	$(RMDIR) -p $(datadir) 2>/dev/null || true
