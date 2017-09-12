#
# Makefile --Build rules for devkit/lib/sh.
#
# Remarks:
# This directory contains shell library code; at the moment
# an implementation of the tap protocol.
#
language = sh
SHL_SRC = tap.shl test-more.shl
LOCAL.SH_LINT_FLAGS = -e SC2034,SC2039,SC2059,SC2064,SC2154

include devkit.mk

install:	install-all
uninstall:	uninstall-all
