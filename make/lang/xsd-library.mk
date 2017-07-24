#
# XSD-LIBRARY.MK --Rules for libraries containing XSD objects.
#
# Contents:
# pre-build-lib-xsd:   --Install headers into library root, via lib's pre-build.
# clean-lib:           --Remove the staged include files.
# install-lib-include-xsd: --Install a library's include files.
#

ALL_XSD_H++ = $(XSD_H++) $(gendir)/$(XML_SCHEMA).$(H++_SUFFIX)

LIB_INCLUDEDIR_XSD = $(ALL_XSD_H++:$(gendir)/%=$(LIB_INCLUDEDIR)/%)

$(archdir)/lib.a:	$(XSD_OBJ)

#
# pre-build-lib-xsd: --Install headers into library root, via lib's pre-build.
#
# Remarks:
# library.mk defines LIB_INCLUDEDIR, and pre-build-lib.
#
.PHONY: pre-build-lib-xsd
pre-build-lib: pre-build-lib-xsd
pre-build-lib-xsd: $(LIB_INCLUDEDIR_XSD)

#
# The XSD objects depend on the generated/staged include files.
# This dependency is a bit broad; all the objects will be rebuilt if
# any of the sources are touched...
# TODO: better dependency declaration for XSD library files.
#
$(XSD_OBJ): $(LIB_INCLUDEDIR_XSD)

#
# clean-lib: --Remove the staged include files.
#
.PHONY: clean-lib-xsd
clean-lib: clean-lib-xsd
clean-lib-xsd:; $(RM) $(LIB_INCLUDEDIR_XSD)

#
# install-lib-include-xsd: --Install a library's include files.
#
# Remarks:
# These targets customise the library.mk's (un)install-lib-include target.
#
.PHONY: install-lib-include-xsd
install-lib-include:	install-lib-include-xsd
install-lib-include-xsd:  $(ALL_XSD_H++:$(gendir)/%=$(includedir)/%)

.PHONY: uninstall-lib-include-xsd
uninstall-lib-include:	uninstall-lib-include-xsd
uninstall-lib-include-xsd:; $(RM) $(ALL_XSD_H++:$(gendir)/%=$(includedir)/%)
