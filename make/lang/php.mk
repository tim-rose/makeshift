#
# PHP.MK --Rules for building PHP objects and programs.
#
# Contents:
# php-build: --Make scripts "executable".
# php-toc:   --Build the table-of-contents for PHP-ish files.
# php-src:   --php-specific customisations for the "src" target.
# todo:      --Report unfinished work (identified by keyword comments)
#
PHP_TRG = $(PHP_SRC:%.php=%)

#
# %.php:		--Rules for installing php scripts
#
%:			%.php;	@$(INSTALL_SCRIPT) $(PHP_PATH) $? $@
$(bindir)/%:		%.php;	@$(INSTALL_SCRIPT) $(PHP_PATH) $? $@
$(libexecdir)/%:	%.php;	@$(INSTALL_SCRIPT) $(PHP_PATH) $? $@
$(wwwdir)/%.php:	%.php;	$(INSTALL_FILE) $? $@

#
# php-build: --Make scripts "executable".
#
pre-build:	var-defined[PHP_SRC]

#
# php-toc: --Build the table-of-contents for PHP-ish files.
#
.PHONY: php-toc
toc:	php-toc
php-toc:
	$(ECHO_TARGET)
	mk-toc $(PHP_SRC)

#
# php-src: --php-specific customisations for the "src" target.
#
src:	php-src
.PHONY:	php-src
php-src:	
	$(ECHO_TARGET)
	@mk-filelist -qn PHP_SRC *.php

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: php-todo
todo:	php-todo
php-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(PHP_SRC) /dev/null || true

