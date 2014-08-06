#
# Makefile --Build rules the make directory of devkit.
#
MAKEFLAGS = -I ../make
SRC_LANG	= sh

AWK_SRC = awk-tidy.awk
SH_SRC = echo+.sh mk-ar-merge.sh mk-ar.sh mk-filelist.sh mk-toc.sh \
    skel.sh svn-checkout.sh svn-edit.sh svn-import.sh \
    svn-keyword.sh svn-releases.sh

include devkit.mk

install:	$(SH_SRC:%.sh=$(bindir)/%) $(AWK_SRC:%.awk=$(bindir)/%)
