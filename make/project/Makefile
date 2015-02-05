#
# Makefile --Build rules for the project directory of devkit.
#
# Remarks:
# This just installs a default project file, it's up to
# particular projects to copy in their own project-specific stuff.
#
MK_SRC = project.mk
SRC = $(MK_SRC) .mk
subdir	= project

include devkit.mk

$(includedir)/.mk:	_mk.sh
	$(INSTALL_DIRECTORY) $(includedir)
	sh _mk.sh >$@

install:	$(SRC:%=$(includedir)/%)
