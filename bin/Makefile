#
# Makefile --Build rules devkit/bin.
#
SRC_LANG	= sh

AWK_SRC = awk-tidy.awk
SH_SRC = echo+.sh mk-ar-merge.sh mk-ar.sh mk-filelist.sh mk-help.sh \
    mk-toc.sh svn-checkout.sh svn-edit.sh svn-import.sh \
    svn-keyword.sh svn-releases.sh

include devkit.mk

install:	$(SHELL_TRG:%=$(bindir)/%)
