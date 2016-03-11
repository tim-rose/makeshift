#
# Makefile --Build rules for devkit, the developer utilities kit.
#
package-type = rpm deb
PACKAGE = devkit
VERSION = 0.2.3

include devkit.mk package.mk

$(STAGING_ROOT):
	$(ECHO_TARGET)
	$(MAKE) install DESTDIR=$$(pwd)/$@ prefix=/usr/local usr=$(usr) opt=$(opt)

devkit.mk:
	@echo "you need to do a self-hosted install:"
	@echo "    sh install.sh [make-arg.s...]"
	@false

install:	$(includedir)/version.mk
$(includedir)/version.mk:
	{ echo 'DEVKIT_VERSION=$(DEVKIT_VERSION)'; \
          echo 'DEVKIT_RELEASE=$(DEVKIT_RELEASE)/';} >$@
