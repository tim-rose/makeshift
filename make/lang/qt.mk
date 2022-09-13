#
# QT.MK --Rules for building Qt GUI applications
#
# Contents:
# build: --Build the Qt files.
# clean: --Remove objects and intermediates created from Qt files.
# src:   --Update the QTH_SRC, QTR_SRC macros.
# todo:  --Find "unfinished work" comments in QT files.
#
# Remarks:
# The qt module adds support for building Qt-related software.
# It defines some pattern rules for compiling ".qrc" files,
# and ".h" files that contain Qt definitions.  These rules
# will be applied to files defined by the macros:
#
#  * QTR_SRC -- ".qrc" files
#  * QTH_SRC -- ".h" files containing QT_OBJECT usage.
#
# The "src" target will update the current makefile with suitable
# definitions of these macros; it uses the value of $(H++_SUFFIX)
# to find $(QTH_SRC) candidates, and $(C++_SUFFIX) to name
# generated C++ files.
#
.PHONY: $(recursive-targets:%=%-qt)

-include $(QTR_SRC:%.qrc=$(archdir)/%.d) $(UI_SRC:%.qrc=$(archdir)/%.d)

RCC	?= rcc
MOC	?= moc
UIC	?= uic
QT	?= Core Gui

C++_SUFFIX ?= cc
H++_SUFFIX ?= h
QRC_SUFFIX ?= qrc
QUI_SUFFIX ?= ui

ifdef autosrc
    LOCAL_QTR_SRC := $(wildcard *.$(QRC_SUFFIX)
    LOCAL_QUI_SRC := $(wildcard *.$(QUI_SUFFIX))
    LOCAL_QTH_SRC := $(shell grep -l Q_OBJECT *.$(H++_SUFFIX) 2>/dev/null)

    QTR_SRC ?= $(LOCAL_QTR_SRC)
    QUI_SRC ?= $(LOCAL_QUI_SRC)
    QTH_SRC ?= $(LOCAL_QTH_SRC)
endif

QT_INCLUDES = $(QT:%=-I/usr/include/Qt%)
QT_LIBS = $(QT:%=-lQt%)

ALL_RCC_FLAGS = $(OS.RCC_FLAGS) $(ARCH.RCC_FLAGS) \
    $(PROJECT.RCC_FLAGS) $(LOCAL.RCC_FLAGS) $(TARGET.RCC_FLAGS) $(RCC_FLAGS)

ALL_MOC_FLAGS = $(OS.MOC_FLAGS) $(ARCH.MOC_FLAGS) \
    $(PROJECT.MOC_FLAGS) $(LOCAL.MOC_FLAGS) $(TARGET.MOC_FLAGS) $(MOC_FLAGS)

ALL_UIC_FLAGS = $(OS.UIC_FLAGS) $(ARCH.UIC_FLAGS) \
    $(PROJECT.UIC_FLAGS) $(LOCAL.UIC_FLAGS) $(TARGET.UIC_FLAGS) $(UIC_FLAGS)

QTR_TRG = $(QTR_SRC:%.$(QRC_SUFFIX)=$(gendir)/%.$(C++_SUFFIX))
QTH_TRG = $(QTH_SRC:%.$(H++_SUFFIX)=$(gendir)/%_moc.$(C++_SUFFIX))
QUI_TRG = $(QUI_SRC:%.$(QUI_SUFFIX)=$(gendir)/%_$(QUI_SUFFIX).$(H++_SUFFIX))
QT_TRG  = $(QTR_TRG) $(QTH_TRG) $(QUI_TRG)

ifdef o
QTR_OBJ = $(QTR_TRG:$(gendir)/%.$(C++_SUFFIX)=$(archdir)/%.$(o))
QTH_OBJ = $(QTH_TRG:$(gendir)/%.$(C++_SUFFIX)=$(archdir)/%.$(o))
endif
ifdef s.o
QTR_PIC_OBJ = $(QTR_TRG:$(gendir)/%.$(C++_SUFFIX)=$(archdir)/%.$(s.o))
QTH_PIC_OBJ = $(QTH_TRG:$(gendir)/%.$(C++_SUFFIX)=$(archdir)/%.$(s.o))
endif

QT_OBJ  = $(QTR_OBJ) $(QTH_OBJ)
QT_PIC_OBJ = $(QTR_PIC_OBJ) $(QTH_PIC_OBJ)

.PRECIOUS:	$(QT_TRG)
#
# build: --Build the Qt files.
#
build:	$(QT_OBJ) $(QTR_PIC_OBJ) $(QT_TRG)

$(gendir)/%.$(C++_SUFFIX):	%.qrc | $(gendir)
	$(ECHO_TARGET)
	$(RCC) $(ALL_RCC_FLAGS) $(abspath $<) >$@

$(gendir)/%_moc.$(C++_SUFFIX):	%.$(H++_SUFFIX) | $(gendir)
	$(ECHO_TARGET)
	$(MOC) $(ALL_MOC_FLAGS) -o $@ $(abspath $<)

$(gendir)/%_$(QUI_SUFFIX).$(H++_SUFFIX):	%.$(QUI_SUFFIX) | $(gendir)
	$(ECHO_TARGET)
	$(UIC) $(ALL_UIC_FLAGS) -o $@ $(abspath $<)

#
# clean: --Remove objects and intermediates created from Qt files.
#
clean:	clean-qt
clean-qt:
	$(ECHO_TARGET)
	$(RM) $(QT_TRG) $(QT_OBJ) $(QT_PIC_OBJ)

#
# src: --Update the QTH_SRC, QTR_SRC macros.
#
src:	src-qt
src-qt:
	$(ECHO_TARGET)
	$(Q)mk-filelist -f $(MAKEFILE) -qn QTR_SRC *.$(QRC_SUFFIX)
	$(Q)mk-filelist -f $(MAKEFILE) -qn QUI_SRC *.$(QUI_SUFFIX)
	$(Q)mk-filelist -f $(MAKEFILE) -qn QTH_SRC $$(grep -l Q_OBJECT *.$(H++_SUFFIX))

#
# todo: --Find "unfinished work" comments in QT files.
#
todo:	todo-qt
todo-qt:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(QTR_SRC) $(QUI_SRC) $(QTH_SRC) /dev/null ||:
