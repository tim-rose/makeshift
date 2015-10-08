#
# XSD.MK --Support for XSD.
#
# Remarks:
# The XSD module adds some rules for building C++ marshalling routines
# from ".xsd" files.  The code is generated into $(archdir), so it won't
# interfere with any existing C++ files.
#
# There's some dependency/fragility here, in that the XSD stuff assumes
# that you're also including the C++ module, and the library module.
# In particular, it assumes that $(LIB_ROOT) is defined, and it attempts
# to install ".$(H++_SUFFIX)" files in the "pre-build" phase, just like the library
# module does.
#
# REVISIT: XmlSchema.h behaviour is broken: install triggers build!
#
.PHONY: $(recursive-targets:%=%-xsd)

-include $(XSD_SRC:%.xsd=$(archdir)/%-depend.mk)

C++_SUFFIX ?= cc
H++_SUFFIX ?= h

XSD_OBJ	= $(XSD_SRC:%.xsd=$(archdir)/%.o)
XSD_H++ = $(XSD_SRC:%.xsd=$(archdir)/%.$(H++_SUFFIX))
XSD_C++ = $(XSD_SRC:%.xsd=$(archdir)/%.$(C++_SUFFIX))

XSD_INCLUDEDIR=$(LIB_ROOT)/include/$(subdir)
XSD_INCLUDE_SRC = $(XSD_H++:$(archdir)/%.$(H++_SUFFIX)=$(XSD_INCLUDEDIR)/%.$(H++_SUFFIX)) \
	$(XSD_INCLUDEDIR)/XmlSchema.$(H++_SUFFIX)

XSD.FLAGS = $(OS.XSDFLAGS) $(ARCH.XSDFLAGS) \
	$(PROJECT.XSDFLAGS) $(LOCAL.XSDFLAGS) $(TARGET.XSDFLAGS) $(XSDFLAGS)

$(XSD_INCLUDEDIR)/%.$(H++_SUFFIX): $(archdir)/%.$(H++_SUFFIX)
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@

$(archdir)/%.$(C++_SUFFIX) $(archdir)/%.$(H++_SUFFIX):	%.xsd
	$(ECHO_TARGET)
	mkdir -p $(archdir)
	xsd cxx-tree --output-dir $(archdir) $(XSD.FLAGS) \
		--extern-xml-schema $(archdir)/XmlSchema.$(H++_SUFFIX) $*.xsd
#
# build: --xsd-specific customisations for the "build" target.
#
$(XSD_OBJ):	$(XSD_INCLUDE_SRC)
pre-build:      var-defined[XSD_INCLUDEDIR] $(XSD_INCLUDE_SRC)
build:	$(XSD_OBJ)

xsd-install-include:	$(XSD_H++:$(archdir)/%.$(H++_SUFFIX)=$(includedir)/%.$(H++_SUFFIX))

$(archdir)/XmlSchema.$(H++_SUFFIX):
	$(ECHO_TARGET)
	mkdir -p $(archdir)
	xsd cxx-tree --output-dir $(archdir) \
		--options-file XmlSchema.conf \
		--generate-xml-schema XmlSchema.$(H++_SUFFIX)

#
# clean: --Remove XSD's object files.
#
clean:	clean-xsd
clean-xsd:
	$(RM) $(XSD_OBJ)

#
# distclean: --Remove XSD-generated include files.
#
distclean:	distclean-xsd clean-xsd
distclean-xsd:
	$(RM) $(XSD_INCLUDE_SRC)

#
# src: --Update the XSD_SRC target.
#
src:	src-xsd
src-xsd:
	$(ECHO_TARGET)
	@mk-filelist -qn XSD_SRC *.xsd
