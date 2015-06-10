#
# Makefile --Build rules for the make directory of devkit.
#
# Contents:
#
# Remarks:
# The "toc" target cannot be run until things have been installed in DEV_HOME.
#
MK_SRC = coverage.mk deb.mk deploy.mk devkit.mk doxygen.mk ld.mk \
    library.mk package.mk recursive-targets.mk repository.mk \
    valid.mk

include devkit.mk

$(includedir)/%:	%;		$(INSTALL_FILE) $< $@
install:		$(MK_SRC:%.mk=$(includedir)/%.mk)
