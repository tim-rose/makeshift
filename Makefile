#
# Makefile --Build rules for devkit, the developer utilities kit.
#
package-type = rpm deb
PACKAGE = devkit
VERSION = 0.3.0
RELEASE = 1

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
	{ echo 'DEVKIT_VERSION=$(VERSION)'; \
          echo 'DEVKIT_RELEASE=$(RELEASE)';} >$@

uninstall:	uninstall-this
uninstall-this:
	$(ECHO_TARGET)
	$(RM) $(includedir)/version.mk
	$(RMDIR) -p $(includedir) 2>/dev/null || true
