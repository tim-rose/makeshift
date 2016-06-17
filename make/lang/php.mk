#
# PHP.MK --Rules for building PHP objects and programs.
#
# Contents:
# toc:            --Build the table-of-contents for PHP-ish files.
# src:            --Define the PHP_SRC macro.
# todo:           --Report unfinished work in PHP source code.
# system-php.ini: --Create a PHP configuration file based on current system settings.
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
# toc: --Build the table-of-contents for PHP-ish files.
#
toc:	toc-php
toc-php:
	$(ECHO_TARGET)
	mk-toc $(PHP_SRC)

#
# src: --Define the PHP_SRC macro.
#
src:	src-php
src-php:
	$(ECHO_TARGET)
	@mk-filelist -qn PHP_SRC *.php

#
# todo: --Report unfinished work in PHP source code.
#
todo:	todo-php
todo-php:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(PHP_SRC) /dev/null || true

#
# system-php.ini: --Create a PHP configuration file based on current system settings.
#
# Remarks:
# This can be helpful for testing.  This is a hack to get me started...
#
system-php.ini:
	php -i | sed -e '/=>.*=>/!d' -e '/^Directive/d' -e '/=> no value/d' -e 's/=>/=/' -e 's/=>.*//' >$@
