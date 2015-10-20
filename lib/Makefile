#
# Makefile --Build rules for devkit/lib.
#
# Remarks:
# This directory contains shell library code; at the moment
# an implementation of the tap protocol.
#
language = sh
SHL_SRC = tap.shl
subdir = sh

include devkit.mk

install:	$(SHL_SRC:%=$(libdir)/%)
