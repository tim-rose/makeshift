#
# QT.MK --Rules for building Qt GUI applications
#
# Contents:
# build: --Build the Qt files
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

#-include $(QTH_SRC:%.$(H++_SUFFIX)=$(archdir)/%-depend.mk)
RCC	?= rcc
MOC	?= moc

C++_SUFFIX ?= cc
H++_SUFFIX ?= h
QRC_SUFFIX ?= qrc

QTR_TRG = $(QTR_SRC:%.$(QRC_SUFFIX)=$(archdir)/%.$(C++_SUFFIX))
QTH_TRG = $(QTH_SRC:%.$(H++_SUFFIX)=$(archdir)/moc-%.$(C++_SUFFIX))
QT_TRG  = $(QTR_TRG) $(QTH_TRG)

QTR_OBJ = $(QTR_TRG:%.$(C++_SUFFIX)=%.o)
QTH_OBJ = $(QTH_TRG:%.$(C++_SUFFIX)=%.o)
QT_OBJ  = $(QTR_OBJ) $(QTH_OBJ)

#
# build: --Build the Qt files
#
build:	$(QT_OBJ)

$(archdir)/%.$(C++_SUFFIX): %.qrc
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	$(RCC) $< >$@

$(archdir)/moc-%.$(C++_SUFFIX): %.$(H++_SUFFIX)
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	$(MOC) -o $@ $<

#
# clean: --Remove objects and intermediates created from Qt files.
#
clean:	clean-qt
clean-qt:
	$(ECHO_TARGET)
	$(RM) $(QT_TRG) $(QT_OBJ)

#
# src: --Update the QTH_SRC, QTR_SRC macros.
#
src:	src-qt
src-qt:
	$(ECHO_TARGET)
	@mk-filelist -qn QTR_SRC *.qrc
	@mk-filelist -qn QTH_SRC $$(grep -l Q_OBJECT *.$(H++_SUFFIX))

#
# todo: --Find "unfinished work" comments in QT files.
#
todo:	todo-qt
todo-qt:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(QTH_SRC) $(QTR_SRC) /dev/null || true
