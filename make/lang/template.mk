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
xxx-all:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# install: --xxx-specific customisations for the "install" target.
#
install:	xxx-install
.PHONY:	xxx-install
xxx-install:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# installdirs: --xxx-specific customisations for the "installdirs" target.
#
installdirs:	xxx-installdirs
.PHONY:	xxx-installdirs
xxx-installdirs:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# uninstall: --xxx-specific customisations for the "uninstall" target.
#
uninstall:	xxx-uninstall
.PHONY:	xxx-uninstall
xxx-uninstall:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# install-strip: --xxx-specific customisations for the "install-strip" target.
#
install-strip:	xxx-install-strip
.PHONY:	xxx-install-strip
xxx-install-strip:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# clean: --xxx-specific customisations for the "clean" target.
#
clean:	xxx-clean
.PHONY:	xxx-clean
xxx-clean:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# distclean: --xxx-specific customisations for the "distclean" target.
#
distclean:	xxx-distclean
.PHONY:	xxx-distclean
xxx-distclean:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# mostlyclean: --xxx-specific customisations for the "mostlyclean" target.
#
mostlyclean:	xxx-mostlyclean
.PHONY:	xxx-mostlyclean
xxx-mostlyclean:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# maintainer-clean: --xxx-specific customisations for the "" target.
#
maintainer-clean:	xxx-maintainer-clean
.PHONY:	xxx-maintainer-clean
xxx-maintainer-clean:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# tags: --xxx-specific customisations for the "tags" target.
#
tags:	xxx-tags
.PHONY:	xxx-tags
xxx-tags:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# dist: --xxx-specific customisations for the "dist" target.
#
dist:	xxx-dist
.PHONY:	xxx-dist
xxx-dist:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# build: --xxx-specific customisations for the "build" target.
#
pre-build:	src-var-defined[XXX_SRC]
build:	xxx-build
.PHONY:	xxx-build
xxx-build:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# src: --xxx-specific customisations for the "src" target.
#
src:	xxx-src
.PHONY:	xxx-src
xxx-src:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# depend: --xxx-specific customisations for the "depend" target.
#
depend:	xxx-depend
.PHONY:	xxx-depend
xxx-depend:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# test: --xxx-specific customisations for the "test" target.
#
test:	xxx-test
.PHONY:	xxx-test
xxx-test:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# toc: --xxx-specific customisations for the "toc" target.
#
toc:	xxx-toc
.PHONY:	xxx-toc
xxx-toc:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# tidy: --xxx-specific customisations for the "tidy" target.
#
tidy:	xxx-tidy
.PHONY:	xxx-tidy
xxx-tidy:	;	@$(ECHO) "++ make[$@]@$$PWD"

#
# doc: --xxx-specific customisations for the "doc" target.
#
doc:	xxx-doc
.PHONY:	xxx-doc
xxx-doc:	;	@$(ECHO) "++ make[$@]@$$PWD"
