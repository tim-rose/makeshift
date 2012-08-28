#
# Makefile --Build rules the make directory of devkit.
#
SRC_LANG	= sh
MAKEFLAGS = -I ../make

SH_SRC = echo+.sh mk-ar.sh mk-filelist.sh mk-toc.sh svn-checkout.sh \
    svn-edit.sh svn-import.sh svn-keyword.sh svn-releases.sh

include devkit.mk

installdirs:	$(bindir) $(libexecdir)
install:	$(SH_SRC:%.sh=$(bindir)/%)
