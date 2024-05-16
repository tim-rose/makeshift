#
# component.mk --Support for downloading components.
#
# Remarks:
# The component package provides support for downloading 
# components from a git VCS.
#
# The components are defined in a components file
#
COMPONENTS ?= components.conf
components ?= $(shell sed -ne '/^#/d;s/:.*//p' ${COMPONENTS} )

.PHONY: components
components: $(components:%=component[%])

component[%]:; mk-vcs-get -v $*
