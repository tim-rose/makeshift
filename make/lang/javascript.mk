#
# JAVASCRIPT.MK --Rules for dealing with JavaScript files.
#
# Contents:
# toc-javascript: --Build the table-of-contents for JavaScript files.
# src-javascript: --Update the JS_SRC macro.
# todo:           --Report "unfinished work" comments in JavaScript files.
#
.PHONY: $(recursive-targets:%=%-javascript)

$(wwwdir)/%.js:	%.js;	$(INSTALL_FILE) $? $@

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
	@mk-filelist -qn JS_SRC *.js

#
# todo: --Report "unfinished work" comments in JavaScript files.
#
todo:	todo-javascript
todo-javascript:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(JS_SRC) /dev/null || true
