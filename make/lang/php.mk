#
# PHP.MK --Rules for building PHP objects and programs.
#
# Contents:
# php-build: --Make scripts "executable".
# toc-php:   --Build the table-of-contents for PHP-ish files.
# src-php:   --php-specific customisations for the "src" target.
# todo:      --Report unfinished work (identified by keyword comments)
#
.PHONY: $(recursive-targets:%=%-php)
phplibdir      = $(exec_prefix)/lib/php/$(subdir)

#
# %.php:		--Rules for installing php scripts
#
$(phplibdir)/%.php:    	%.php;	$(INSTALL_FILE) $? $@
$(wwwdir)/%.php:	%.php;	$(INSTALL_FILE) $? $@
$(bindir)/%:		%.php;	$(INSTALL_PROGRAM) $? $@

install-lib-php:	$(PHP_SRC:%.php=$(phplibdir)/%.php)
install-www-php:	$(PHP_SRC:%.php=$(wwwdir)/%.php)

#
# php-build: --Make scripts "executable".
#
pre-build:	var-defined[PHP_SRC]

#
# toc-php: --Build the table-of-contents for PHP-ish files.
#
toc:	toc-php
toc-php:
	$(ECHO_TARGET)
	mk-toc $(PHP_SRC)

#
# src-php: --php-specific customisations for the "src" target.
#
src:	src-php
src-php:
	$(ECHO_TARGET)
	@mk-filelist -qn PHP_SRC *.php

#
# todo: --Report unfinished work (identified by keyword comments)
#
todo:	todo-php
todo-php:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(PHP_SRC) /dev/null || true
