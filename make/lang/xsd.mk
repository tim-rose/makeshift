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
# from ".xsd" files.  The code is generated into $(archdir), so it won't
# interfere with any existing C++ files.
#
# REVISIT: XmlSchema.h behaviour is broken: install triggers build!
#
.PHONY: $(recursive-targets:%=%-xsd)

-include $(XSD_SRC:%.xsd=$(archdir)/%-depend.mk)

C++_SUFFIX ?= cc
H++_SUFFIX ?= h

XSD ?= xsd
XML_SCHEMA ?= XmlSchema

XSD_OBJ	= $(XSD_SRC:%.xsd=$(archdir)/%.o)
XSD_H++ = $(XSD_SRC:%.xsd=$(archdir)/%.$(H++_SUFFIX))
XSD_C++ = $(XSD_SRC:%.xsd=$(archdir)/%.$(C++_SUFFIX))

.PRECIOUS: $(XSD_H++) $(XSD_C++)

XSD.FLAGS = $(OS.XSDFLAGS) $(ARCH.XSDFLAGS) \
	$(PROJECT.XSDFLAGS) $(LOCAL.XSDFLAGS) $(TARGET.XSDFLAGS) $(XSDFLAGS)

$(datadir)/%.xsd:	%.xsd
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@

$(archdir)/%.$(C++_SUFFIX) $(archdir)/%.$(H++_SUFFIX):	%.xsd
	$(ECHO_TARGET)
	mkdir -p $(archdir)
	$(XSD) cxx-tree --output-dir $(archdir) $(XSD.FLAGS) \
		--extern-xml-schema $(archdir)/$(XML_SCHEMA).$(H++_SUFFIX) $*.xsd 2>/dev/null

#
# build: --Build XSD objects via C++.
#
build:	$(XSD_OBJ)

#
# install-xsd: --Install the XSD files into datadir.
#
.PHONY: install-xsd
install-xsd: $(XSD_SRC:%=$(datadir)/%)

#
# uninstall-xsd: --Remove XSD files and related include files.
#
.PHONY: uninstall-xsd-xsd uninstall-xsd-include
uninstall-xsd:	uninstall-xsd-xsd uninstall-xsd-include
	$(ECHO_TARGET)
	$(RM) $(XSD_SRC:%=$(datadir)/%)
	$(RMDIR) -p $(datadir) 2>/dev/null || true

$(archdir)/$(XML_SCHEMA).$(H++_SUFFIX):
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	$(XSD) cxx-tree --output-dir $(archdir) \
		--options-file $(XML_SCHEMA).conf \
		--generate-xml-schema $@ 2>/dev/null

#
# clean: --Remove XSD's object files.
#
clean:	clean-xsd
distclean: clean-xsd
clean-xsd:
	$(RM) $(XSD_OBJ)

#
# src: --Update the XSD_SRC target.
#
src:	src-xsd
src-xsd:
	$(ECHO_TARGET)
	@mk-filelist -qn XSD_SRC *.xsd
