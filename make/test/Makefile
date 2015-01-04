#
# Makefile --Build rules for the test directory of devkit.
#
# Remarks:
# This directory contains some helper rules for various 
# test frameworks.
#
MK_SRC = google.mk tap.mk
subdir	= test

include devkit.mk 

$(includedir)/%:	%;		$(INSTALL_FILE) $< $@

install:		$(MK_SRC:%=$(includedir)/%)
