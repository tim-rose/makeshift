#
# targets.mk --auto-recursive targets, generated Fri May 25 10:05:15 2012
#

#
# all: --auto-recursive target
#
.PHONY:	all
all:	$(SUBDIRS:%=all@%)
$(SUBDIRS:%=all@%):	pre-all
pre-all:	;
all@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) all; fi

#
# install: --auto-recursive target
#
.PHONY:	install
install:	$(SUBDIRS:%=install@%)
$(SUBDIRS:%=install@%):	pre-install
pre-install:	;
install@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) install; fi

#
# installdirs: --auto-recursive target
#
.PHONY:	installdirs
installdirs:	$(SUBDIRS:%=installdirs@%)
$(SUBDIRS:%=installdirs@%):	pre-installdirs
pre-installdirs:	;
installdirs@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) installdirs; fi

#
# uninstall: --auto-recursive target
#
.PHONY:	uninstall
uninstall:	$(SUBDIRS:%=uninstall@%)
$(SUBDIRS:%=uninstall@%):	pre-uninstall
pre-uninstall:	;
uninstall@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) uninstall; fi

#
# install-strip: --auto-recursive target
#
.PHONY:	install-strip
install-strip:	$(SUBDIRS:%=install-strip@%)
$(SUBDIRS:%=install-strip@%):	pre-install-strip
pre-install-strip:	;
install-strip@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) install-strip; fi

#
# clean: --auto-recursive target
#
.PHONY:	clean
clean:	$(SUBDIRS:%=clean@%)
$(SUBDIRS:%=clean@%):	pre-clean
pre-clean:	;
clean@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) clean; fi

#
# distclean: --auto-recursive target
#
.PHONY:	distclean
distclean:	$(SUBDIRS:%=distclean@%)
$(SUBDIRS:%=distclean@%):	pre-distclean
pre-distclean:	;
distclean@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) distclean; fi

#
# tags: --auto-recursive target
#
.PHONY:	tags
tags:	$(SUBDIRS:%=tags@%)
$(SUBDIRS:%=tags@%):	pre-tags
pre-tags:	;
tags@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) tags; fi

#
# dist: --auto-recursive target
#
.PHONY:	dist
dist:	$(SUBDIRS:%=dist@%)
$(SUBDIRS:%=dist@%):	pre-dist
pre-dist:	;
dist@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) dist; fi

#
# build: --auto-recursive target
#
.PHONY:	build
build:	$(SUBDIRS:%=build@%)
$(SUBDIRS:%=build@%):	pre-build
pre-build:	;
build@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) build; fi

#
# src: --auto-recursive target
#
.PHONY:	src
src:	$(SUBDIRS:%=src@%)
$(SUBDIRS:%=src@%):	pre-src
pre-src:	;
src@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) src; fi

#
# depend: --auto-recursive target
#
.PHONY:	depend
depend:	$(SUBDIRS:%=depend@%)
$(SUBDIRS:%=depend@%):	pre-depend
pre-depend:	;
depend@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) depend; fi

#
# test: --auto-recursive target
#
.PHONY:	test
test:	$(SUBDIRS:%=test@%)
$(SUBDIRS:%=test@%):	pre-test
pre-test:	;
test@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) test; fi

#
# toc: --auto-recursive target
#
.PHONY:	toc
toc:	$(SUBDIRS:%=toc@%)
$(SUBDIRS:%=toc@%):	pre-toc
pre-toc:	;
toc@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) toc; fi

#
# tidy: --auto-recursive target
#
.PHONY:	tidy
tidy:	$(SUBDIRS:%=tidy@%)
$(SUBDIRS:%=tidy@%):	pre-tidy
pre-tidy:	;
tidy@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) tidy; fi

#
# doc: --auto-recursive target
#
.PHONY:	doc
doc:	$(SUBDIRS:%=doc@%)
$(SUBDIRS:%=doc@%):	pre-doc
pre-doc:	;
doc@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) doc; fi

#
# todo: --auto-recursive target
#
.PHONY:	todo
todo:	$(SUBDIRS:%=todo@%)
$(SUBDIRS:%=todo@%):	pre-todo
pre-todo:	;
todo@%:
	@if [ -e $*/Makefile ]; then cd $* && $(MAKE) todo; fi
