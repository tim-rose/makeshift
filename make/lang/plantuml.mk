#
# PLANTUML.MK --Rules for dealing with PlantUML files.
#
# Contents:
# %.svg/%.puml:   --Create a PNG file from a PlantUML definition.
# %.png/%.puml:   --Create a PNG file from a PlantUML definition.
# %.eps/%.puml:   --Create an EPS file from a PlantUML definition.
# clean-plantuml: --Clean up plantuml's derived files.
# src-plantuml:   --Update PUML_SRC macro.
# todo-plantuml:  --Report unfinished work in plantuml files.
# +version:       --Report details of tools used by plantuml.
#
# Remarks:
# TBD.
#
# See Also:
# http://alistapart.com/article/building-books-with-css3
# http://www.princexml.com/doc
#
.PHONY: $(recursive-targets:%=%-plantuml)

PRINT_plantuml_VERSION = plantuml -version

ALL_PUMLFLAGS ?= $(OS.PUMLFLAGS) $(ARCH.PUMLFLAGS) $(PROJECT.PUMLFLAGS) \
    $(LOCAL.PUMLFLAGS) $(TARGET.PUMLFLAGS) $(PUMLFLAGS)

ifdef autosrc
    LOCAL_PUML_SRC := $(wildcard *.puml)

    PUML_SRC ?= $(LOCAL_PUML_SRC)
endif

#
# %.svg/%.puml: --Create a PNG file from a PlantUML definition.
#
%.svg:	%.puml
	$(ECHO_TARGET)
	plantuml $(ALL_PUMLFLAGS) -tsvg $*.puml

#
# %.png/%.puml: --Create a PNG file from a PlantUML definition.
#
%.png:	%.puml
	$(ECHO_TARGET)
	plantuml $(ALL_PUMLFLAGS) -tpng $*.puml
#
# %.eps/%.puml: --Create an EPS file from a PlantUML definition.
#
%.eps:	%.puml
	$(ECHO_TARGET)
	plantuml $(ALL_PUMLFLAGS) -teps $*.puml

doc-plantuml:	$(PUML_SRC:%.puml=%.png) $(PUML_SRC:%.puml=%.svg)

#
# clean-plantuml: --Clean up plantuml's derived files.
#
distclean:	clean-plantuml
clean:	clean-plantuml
clean-plantuml:
	$(ECHO_TARGET)
	$(RM) $(PUML_SRC:%.puml=%.png) $(PUML_SRC:%.puml=%.svg) $(PUML_SRC:%.puml=%.eps)

#
# src-plantuml: --Update PUML_SRC macro.
#
src:	src-plantuml
src-plantuml:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qn PUML_SRC *.puml

#
# todo-plantuml: --Report unfinished work in plantuml files.
#
todo:	todo-plantuml
todo-plantuml:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(PUML_SRC) /dev/null ||:

#
# +version: --Report details of tools used by plantuml.
#
+version: cmd-version[plantuml]
