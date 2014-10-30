#
# JAVASCRIPT.MK --Rules for dealing with JavaScript files.
#
# Contents:
# javascript-toc: --Build the table-of-contents for JavaScript files.
# javascript-src: --Update the JS_SRC macro.
# todo:           --Report "unfinished work" comments in JavaScript files.
#
$(wwwdir)/%.js:	%.js;	$(INSTALL_FILE) $? $@

#
# javascript-toc: --Build the table-of-contents for JavaScript files.
#
.PHONY: javascript-toc
toc:	javascript-toc
javascript-toc:
	$(ECHO_TARGET)
	mk-toc $(JS_SRC)
#
# javascript-src: --Update the JS_SRC macro.
#
src:	javascript-src
.PHONY:	javascript-src
javascript-src:
	$(ECHO_TARGET)
	@mk-filelist -qn JS_SRC *.js

#
# todo: --Report "unfinished work" comments in JavaScript files.
#
.PHONY: javascript-todo
todo:	javascript-todo
javascript-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(JS_SRC) /dev/null || true
