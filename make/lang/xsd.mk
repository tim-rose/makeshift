#
# XSD.MK --Support for XSD.
#
# Contents:
# build:         --Build XSD objects via C++.
# install-xsd:   --Install the XSD files into datadir.
# uninstall-xsd: --Remove XSD files and related include files.
# clean:         --Remove XSD's generated and object files.
# src:           --Update the XSD_SRC target.
# +version:      --Report details of tools used by XSD
#
# Remarks:
# The XSD module adds some rules for building C++ marshalling routines
# from ".xsd" files.  The code is generated into $(gendir), so it won't
# interfere with any existing C++ files.
#
# REVISIT: XmlSchema.h behaviour is broken: install triggers build!
#
# See Also:
# https://www.codesynthesis.com/projects/xsd
#
.PHONY: $(recursive-targets:%=%-xsd)

#-include $(XSD_SRC:%.xsd=$(archdir)/%-depend.mk)


ifdef autosrc
    LOCAL_XSD_SRC := $(wildcard *.xsd)

    XSD_SRC ?= $(LOCAL_XSD_SRC)
endif

C++_SUFFIX ?= cc
H++_SUFFIX ?= h

XSD ?= xsd
XML_SCHEMA ?= xml-schema
xsddir = $(exec_prefix)/share/xsd

XSD_OBJ = $(XSD_SRC:%.xsd=$(archdir)/%.$(o))
XSD_PIC_OBJ += $(XSD_SRC:%.xsd=$(archdir)/%.$(s.o))

XSD_H++ = $(XSD_SRC:%.xsd=$(gendir)/%.$(H++_SUFFIX))
XSD_C++ = $(XSD_SRC:%.xsd=$(gendir)/%.$(C++_SUFFIX))

.PRECIOUS: $(XSD_H++) $(XSD_C++)

XSD.FLAGS = $(OS.XSDFLAGS) $(ARCH.XSDFLAGS) \
	$(PROJECT.XSDFLAGS) $(LOCAL.XSDFLAGS) $(TARGET.XSDFLAGS) $(XSDFLAGS)

$(xsddir)/%.xsd:	%.xsd
	$(ECHO_TARGET)
	$(INSTALL_DATA) $? $@

$(gendir)/%.$(C++_SUFFIX) $(gendir)/%.$(H++_SUFFIX):	%.xsd | $(gendir)
	$(ECHO_TARGET)
	$(XSD) cxx-tree --output-dir $(gendir) $(XSD.FLAGS) \
		--extern-xml-schema $(gendir)/$(XML_SCHEMA).$(H++_SUFFIX) $*.xsd 2>/dev/null

#
# build: --Build XSD objects via C++.
#
build:	build-xsd
build-xsd:	$(XSD_OBJ) $(XSD_PIC_OBJ); $(ECHO_TARGET)

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
	$(RMDIR) $(xsddir)

$(gendir)/$(XML_SCHEMA).$(H++_SUFFIX): | $(gendir)
	$(ECHO_TARGET)
	$(XSD) cxx-tree --output-dir $(gendir) \
		--options-file $(XML_SCHEMA).conf \
		--generate-xml-schema $@ 2>/dev/null

#
# clean: --Remove XSD's generated and object files.
#
clean:	clean-xsd
distclean: clean-xsd
clean-xsd:
	$(RM) $(XSD_OBJ) $(XSD_PIC_OBJ) $(XSD_H++) $(XSD_C++)

#
# src: --Update the XSD_SRC target.
#
src:	src-xsd
src-xsd:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qn XSD_SRC *.xsd

#
# +version: --Report details of tools used by XSD
#
+version: cmd-version[$(XSD)]
