#
# Makefile --Build rules for devkit, the developer utilities kit.
#
include devkit.mk

devkit.mk:
	@echo "you need to do a self-hosted install:"
	@echo "    sh install.sh [make-arg.s...]"
	@false
