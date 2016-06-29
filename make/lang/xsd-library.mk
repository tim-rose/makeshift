#
# XSD-LIBRARY.MK --Rules for libraries containing XSD objects.
#
# Contents:
# pre-build-lib:       --Install headers into library root, via lib's pre-build.
# clean-lib:           --Remove the staged include files.
# install-lib-include-xsd: --Install a library's include files.
#
ALL_XSD_H++ = $(XSD_H++) $(archdir)/$(XML_SCHEMA).$(H++_SUFFIX)

#
# pre-build-lib: --Install headers into library root, via lib's pre-build.
#
# Remarks:
# library.mk defines LIB_INCLUDEDIR, and pre-build-lib.
#
.PHONY: pre-build-lib-xsd
pre-build-lib: pre-build-lib-xsd
pre-build-lib-xsd: $(ALL_XSD_H++:$(archdir)/%=$(LIB_INCLUDEDIR)/%)

#
# clean-lib: --Remove the staged include files.
#
.PHONY: clean-lib-xsd
clean-lib: clean-lib-xsd
clean-lib-xsd:; $(RM) $(ALL_XSD_H++:$(archdir)/%=$(LIB_INCLUDEDIR)/%)

#
# install-lib-include-xsd: --Install a library's include files.
#
# Remarks:
# These targets customise the library.mk's (un)install-lib-include target.
#
.PHONY: install-lib-include-xsd
install-lib-include:	install-lib-include-xsd
install-lib-include-xsd:  $(ALL_XSD_H++:$(archdir)/%=$(includedir)/%)

.PHONY: uninstall-lib-include-xsd
uninstall-lib-include:	uninstall-lib-include-xsd
uninstall-lib-include-xsd:; $(RM) $(ALL_XSD_H++:$(archdir)/%=$(includedir)/%)
