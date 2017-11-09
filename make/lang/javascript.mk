#
# JAVASCRIPT.MK --Rules for dealing with JavaScript files.
#
# Contents:
# install-javascript:  --Install JavaScript files to wwwdir(?).
# uninstall-javascript: --Uninstall the default JavaScript files.
# toc-javascript:      --Build the table-of-contents for JavaScript files.
# src-javascript:      --Update the JS_SRC macro.
# todo:                --Report "unfinished work" comments in JavaScript files.
#
.PHONY: $(recursive-targets:%=%-javascript)

ifdef autosrc
    LOCAL_JS_SRC := $(wildcard *.js)

    JS_SRC ?= $(LOCAL_JS_SRC)
endif

$(wwwdir)/%.js:	%.js;	$(INSTALL_DATA) $? $@

#
# install-javascript: --Install JavaScript files to wwwdir(?).
#
install-javascript:	$(JS_SRC:%=$(wwwdir)/%);	$(ECHO_TARGET)

#
# uninstall-javascript: --Uninstall the default JavaScript files.
#
uninstall-javascript:
	$(RM) $(JS_SRC:%=$(wwwdir)/%)
	$(RMDIR) -p $(wwwdir) 2>/dev/null || true

#
# toc-javascript: --Build the table-of-contents for JavaScript files.
#
toc:	toc-javascript
toc-javascript:
	$(ECHO_TARGET)
	mk-toc $(JS_SRC)
#
# src-javascript: --Update the JS_SRC macro.
#
src:	src-javascript
src-javascript:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn JS_SRC *.js

#
# todo: --Report "unfinished work" comments in JavaScript files.
#
todo:	todo-javascript
todo-javascript:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(JS_SRC) /dev/null || true
