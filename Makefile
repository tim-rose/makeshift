#
# Makefile --Build rules for devkit, the developer utilities kit.
#
# Remarks:
# The devkit is really just a grab-bag of scripts and configurations
# for standard tools that happen to be useful in a development
# environment.  Note that devkit is self-hosting in the sense
# that it uses the same make include files etc. as it installs,
# but it uses the ones in the current directory, not the
# installed ones.
#
# TODO: add "package" target to make RPM for linux systems.
# TODO: add a wiki page describing make usage, and the standard targets.
#
SRC_LANG=sh
SH_SRC = devkit-bootstrap.sh

include devkit.mk
install:
installdirs:

targets.mk:
	cd make && $(MAKE) targets.mk
devkit.mk:
	@sh devkit-bootstrap.sh
