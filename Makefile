#
# Makefile --Build rules for devkit, the developer utilities kit.
#
package = rpm
PACKAGE = devkit
VERSION = 0.0
RELEASE = 0

include devkit.mk package.mk

devkit.mk:
	@echo "you need to do a self-hosted install:"
	@echo "    sh install.sh [make-arg.s...]"
	@false
