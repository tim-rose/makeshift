#
# Makefile --Build rules for devkit/libexec
#
# Remarks:
# This directory contains shell library code.
#
LANG=sh
SHL_SRC = tap.shl

include devkit.mk

installdirs:	$(bindir)
install:	$(SHL_SRC:%=$(libexecdir)/%)

