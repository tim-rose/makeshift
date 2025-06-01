#
# JAVASCRIPT.MK --Rules for dealing with JavaScript files.
#
# Contents:
# install-javascript:  --Install JavaScript files to libdir.
# uninstall-javascript: --Uninstall the default JavaScript files.
# toc-javascript:      --Build the table-of-contents for JavaScript files.
# src-javascript:      --Update the JS_SRC macro.
# todo:                --Report "unfinished work" comments in JavaScript files.
# %.json:              --Use cpp(1) and jq(1) to strip comments and blank lines.
#
.PHONY: $(recursive-targets:%=%-javascript)

ifdef autosrc
    LOCAL_JS_SRC := $(wildcard *.js)

    JS_SRC ?= $(LOCAL_JS_SRC)
endif

$(libdir)/%.js:	%.js;	$(INSTALL_DATA) $? $@
$(bindir)/%:	%.js;	$(INSTALL_SCRIPT) $? $@
$(libexecdir)/%:	%.js;	$(INSTALL_SCRIPT) $? $@

#
# install-javascript: --Install JavaScript files to libdir.
#
install-javascript:	$(JS_SRC:%=$(libdir)/%);	$(ECHO_TARGET)

#
# uninstall-javascript: --Uninstall the default JavaScript files.
#
uninstall-javascript:
	$(RM) $(JS_SRC:%=$(libdir)/%)
	$(RMDIR) $(libdir)

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
	$(Q)mk-filelist -f $(MAKEFILE) -qn JS_SRC *.js

#
# todo: --Report "unfinished work" comments in JavaScript files.
#
todo:	todo-javascript
todo-javascript:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(JS_SRC) /dev/null ||:


#
# %.json: --Use cpp(1) and jq(1) to strip comments and blank lines.
#
%.json: %.js
	$(ECHO_TARGET)
	cpp -P -DVERSION='"$(VERSION)"' $*.js | jq . > $@
