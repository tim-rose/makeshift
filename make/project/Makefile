#
# Makefile --Build rules for the project directory of devkit.
#
# Remarks:
# This just installs a default project file, it's up to
# particular projects to copy in their own project-specific stuff.
#
MK_SRC = default.mk
subdir = project

include devkit.mk

install:	$(MK_SRC:%=$(includedir)/%)
