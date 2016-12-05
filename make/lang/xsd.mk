#
# XSD.MK --Support for XSD.
#
# Contents:
# build:         --Build XSD objects via C++.
# install-xsd:   --Install the XSD files into datadir.
# uninstall-xsd: --Remove XSD files and related include files.
# clean:         --Remove XSD's object files.
# src:           --Update the XSD_SRC target.
#
# Remarks:
# The XSD module adds some rules for building C++ marshalling routines
# from ".xsd" files.  The code is generated into $(gendir), so it won't
# interfere with any existing C++ files.
#
# REVISIT: XmlSchema.h behaviour is broken: install triggers build!
#
.PHONY: $(recursive-targets:%=%-xsd)

-include $(XSD_SRC:%.xsd=$(archdir)/%-depend.mk)

C++_SUFFIX ?= cc
H++_SUFFIX ?= h

XSD ?= xsd
XML_SCHEMA ?= xml-schema
xsddir = $(exec_prefix)/share/xsd

XSD_OBJ	= $(XSD_SRC:%.xsd=$(archdir)/%.o)
XSD_H++ = $(XSD_SRC:%.xsd=$(gendir)/%.$(H++_SUFFIX))
XSD_C++ = $(XSD_SRC:%.xsd=$(gendir)/%.$(C++_SUFFIX))

.PRECIOUS: $(XSD_H++) $(XSD_C++)

XSD.FLAGS = $(OS.XSDFLAGS) $(ARCH.XSDFLAGS) \
	$(PROJECT.XSDFLAGS) $(LOCAL.XSDFLAGS) $(TARGET.XSDFLAGS) $(XSDFLAGS)

$(xsddir)/%.xsd:	%.xsd
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@

$(gendir)/%.$(C++_SUFFIX) $(gendir)/%.$(H++_SUFFIX):	%.xsd
	$(ECHO_TARGET)
	$(MKDIR) $(@D)
	$(XSD) cxx-tree --output-dir $(gendir) $(XSD.FLAGS) \
		--extern-xml-schema $(gendir)/$(XML_SCHEMA).$(H++_SUFFIX) $*.xsd 2>/dev/null

#
# build: --Build XSD objects via C++.
#
build:	$(XSD_OBJ)

#
# install-xsd: --Install the XSD files into datadir.
#
.PHONY: install-xsd
install-xsd: $(XSD_SRC:%=$(xsddir)/%)

#
# uninstall-xsd: --Remove XSD files and related include files.
#
.PHONY: uninstall-xsd-xsd uninstall-xsd-include
uninstall-xsd:	uninstall-xsd-xsd uninstall-xsd-include
	$(ECHO_TARGET)
	$(RM) $(XSD_SRC:%=$(xsddir)/%)
	$(RMDIR) -p $(xsddir) 2>/dev/null || true

$(gendir)/$(XML_SCHEMA).$(H++_SUFFIX):
	$(ECHO_TARGET)
	$(MKDIR) $(@D)
	$(XSD) cxx-tree --output-dir $(gendir) \
		--options-file $(XML_SCHEMA).conf \
		--generate-xml-schema $@ 2>/dev/null

#
# clean: --Remove XSD's generated and object files.
#
clean:	clean-xsd
distclean: clean-xsd
clean-xsd:
	$(RM) $(XSD_OBJ) $(XSD_H++) $(XSD_C++)

#
# src: --Update the XSD_SRC target.
#
src:	src-xsd
src-xsd:
	$(ECHO_TARGET)
	@mk-filelist -qn XSD_SRC *.xsd
