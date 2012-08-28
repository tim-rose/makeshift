#
# Contents:
# install:          --xxx-specific customisations for the "install" target.
# install:          --xxx-specific customisations for the "install" target.
# installdirs:      --xxx-specific customisations for the "installdirs" target.
# uninstall:        --xxx-specific customisations for the "uninstall" target.
# install-strip:    --xxx-specific customisations for the "install-strip" target.
# clean:            --xxx-specific customisations for the "clean" target.
# distclean:        --xxx-specific customisations for the "distclean" target.
# mostlyclean:      --xxx-specific customisations for the "mostlyclean" target.
# maintainer-clean: --xxx-specific customisations for the "" target.
# tags:             --xxx-specific customisations for the "tags" target.
# dist:             --xxx-specific customisations for the "dist" target.
# build:            --xxx-specific customisations for the "build" target.
# src:              --xxx-specific customisations for the "src" target.
# depend:           --xxx-specific customisations for the "depend" target.
# test:             --xxx-specific customisations for the "test" target.
# toc:              --xxx-specific customisations for the "toc" target.
# tidy:             --xxx-specific customisations for the "tidy" target.
# doc:              --xxx-specific customisations for the "doc" target.
#
# install: --xxx-specific customisations for the "install" target.
#
all:	xxx-all
.PHONY:	xxx-all
xxx-all:	;	$(ECHO_TARGET)

#
# install: --xxx-specific customisations for the "install" target.
#
install:	xxx-install
.PHONY:	xxx-install
xxx-install:	;	$(ECHO_TARGET)

#
# installdirs: --xxx-specific customisations for the "installdirs" target.
#
installdirs:	xxx-installdirs
.PHONY:	xxx-installdirs
xxx-installdirs:	;	$(ECHO_TARGET)

#
# uninstall: --xxx-specific customisations for the "uninstall" target.
#
uninstall:	xxx-uninstall
.PHONY:	xxx-uninstall
xxx-uninstall:	;	$(ECHO_TARGET)

#
# install-strip: --xxx-specific customisations for the "install-strip" target.
#
install-strip:	xxx-install-strip
.PHONY:	xxx-install-strip
xxx-install-strip:	;	$(ECHO_TARGET)

#
# clean: --xxx-specific customisations for the "clean" target.
#
clean:	xxx-clean
.PHONY:	xxx-clean
xxx-clean:	;	$(ECHO_TARGET)

#
# distclean: --xxx-specific customisations for the "distclean" target.
#
distclean:	xxx-distclean
.PHONY:	xxx-distclean
xxx-distclean:	;	$(ECHO_TARGET)

#
# mostlyclean: --xxx-specific customisations for the "mostlyclean" target.
#
mostlyclean:	xxx-mostlyclean
.PHONY:	xxx-mostlyclean
xxx-mostlyclean:	;	$(ECHO_TARGET)

#
# maintainer-clean: --xxx-specific customisations for the "" target.
#
maintainer-clean:	xxx-maintainer-clean
.PHONY:	xxx-maintainer-clean
xxx-maintainer-clean:	;	$(ECHO_TARGET)

#
# tags: --xxx-specific customisations for the "tags" target.
#
tags:	xxx-tags
.PHONY:	xxx-tags
xxx-tags:	;	$(ECHO_TARGET)

#
# dist: --xxx-specific customisations for the "dist" target.
#
dist:	xxx-dist
.PHONY:	xxx-dist
xxx-dist:	;	$(ECHO_TARGET)

#
# build: --xxx-specific customisations for the "build" target.
#
pre-build:	src-var-defined[XXX_SRC]
build:	xxx-build
.PHONY:	xxx-build
xxx-build:	;	$(ECHO_TARGET)

#
# src: --xxx-specific customisations for the "src" target.
#
src:	xxx-src
.PHONY:	xxx-src
xxx-src:	;	$(ECHO_TARGET)

#
# depend: --xxx-specific customisations for the "depend" target.
#
depend:	xxx-depend
.PHONY:	xxx-depend
xxx-depend:	;	$(ECHO_TARGET)

#
# test: --xxx-specific customisations for the "test" target.
#
test:	xxx-test
.PHONY:	xxx-test
xxx-test:	;	$(ECHO_TARGET)

#
# toc: --xxx-specific customisations for the "toc" target.
#
toc:	xxx-toc
.PHONY:	xxx-toc
xxx-toc:	;	$(ECHO_TARGET)

#
# tidy: --xxx-specific customisations for the "tidy" target.
#
tidy:	xxx-tidy
.PHONY:	xxx-tidy
xxx-tidy:	;	$(ECHO_TARGET)

#
# doc: --xxx-specific customisations for the "doc" target.
#
doc:	xxx-doc
.PHONY:	xxx-doc
xxx-doc:	;	$(ECHO_TARGET)
