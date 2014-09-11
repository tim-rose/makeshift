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
# to install ".hpp" files in the "pre-build" phase, just like the library
# module does.
#
XSD_OBJ	= $(XSD_SRC:%.xsd=$(archdir)/%.o)
XSD_H++ = $(XSD_SRC:%.xsd=$(archdir)/%.hpp)
XSD_C++ = $(XSD_SRC:%.xsd=$(archdir)/%.cpp)

XSD_INCLUDEDIR=$(LIB_ROOT)/include/$(subdir)
XSD_INCLUDE_SRC = $(XSD_H++:$(archdir)/%.hpp=$(XSD_INCLUDEDIR)/%.hpp) \
	$(XSD_INCLUDEDIR)/XmlSchema.hpp

$(XSD_INCLUDEDIR)/%.hpp: $(archdir)/%.hpp
	$(ECHO_TARGET)
	$(INSTALL_FILE) $? $@

$(archdir)/%.cpp $(archdir)/%.hpp:	%.xsd mkdir[$(archdir)]
	$(ECHO_TARGET)
	xsd cxx-tree --output-dir $(archdir) $(XSDFLAGS) --extern-xml-schema $(archdir)/XmlSchema.hpp $*.xsd
#
# build: --xsd-specific customisations for the "build" target.
#
pre-build:      var-defined[XSD_INCLUDEDIR] $(XSD_INCLUDE_SRC)
build:	$(XSD_OBJ)

xsd-install-include:	$(XSD_H++:$(archdir)/%.hpp=$(includedir)/%.hpp)

$(archdir)/XmlSchema.hpp:	mkdir[$(archdir)]
	$(ECHO_TARGET)
	xsd cxx-tree --output-dir $(archdir) \
	    --options-file XmlSchema.conf \
	    --generate-xml-schema XmlSchema.hpp

#
# clean: --xsd-specific customisations for the "clean" target.
#
clean:	xsd-clean
.PHONY:	xsd-clean
xsd-clean:
	$(ECHO_TARGET)
	$(RM) $(XSD_OBJ)

distclean:	xsd-distclean xsd-clean
.PHONY:	xsd-distclean
xsd-distclean:
	$(RM) $(XSD_INCLUDE_SRC)

#
# src: --xsd-specific customisations for the "src" target.
#
src:	xsd-src
.PHONY:	xsd-src
xsd-src:
	$(ECHO_TARGET)
	@mk-filelist -qn XSD_SRC *.xsd
