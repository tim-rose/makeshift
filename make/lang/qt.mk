#
# QT.MK --Rules for building Qt GUI applications
#
# Contents:
# build: --Build the Qt files
# clean: --Remove objects and intermediats created from Qt files.
# src:   --Update the QTH_SRC, QTR_SRC macros.
# todo:  --Find "unfinished work" comments in QT files.
#
#-include $(QTH_SRC:%.$(H++_SUFFIX)=$(archdir)/%-depend.mk)
RCC	?= rcc
MOC	?= moc

C++_SUFFIX ?= cc
H++_SUFFIX ?= h

QTR_TRG = $(QTR_SRC:%.qrc=$(archdir)/%.$(C++_SUFFIX))
QTH_TRG = $(QTH_SRC:%.$(H++_SUFFIX)=$(archdir)/moc-%.$(C++_SUFFIX))
QT_TRG  = $(QTR_TRG) $(QTH_TRG)

QTR_OBJ = $(QTR_TRG:%.$(C++_SUFFIX)=%.o)
QTH_OBJ = $(QTH_TRG:%.$(C++_SUFFIX)=%.o)
QT_OBJ  = $(QTR_OBJ) $(QTH_OBJ)

#
# build: --Build the Qt files
#
build:	$(QT_OBJ)
$(archdir)/%.$(C++_SUFFIX):	%.qrc mkdir[$(archdir)]
	$(RCC) $< >$@
$(archdir)/moc-%.$(C++_SUFFIX):	%.$(H++_SUFFIX) mkdir[$(archdir)]
	$(MOC) -o $@ $<

#
# clean: --Remove objects and intermediates created from Qt files.
#
clean:	qt-clean
.PHONY:	qt-clean
qt-clean:
	$(ECHO_TARGET)
	$(RM) $(QT_TRG) $(QT_OBJ)

#
# src: --Update the QTH_SRC, QTR_SRC macros.
#
src:	qt-src
.PHONY:	qt-src
qt-src:
	$(ECHO_TARGET)
	@mk-filelist -qn QTR_SRC *.qrc
	@mk-filelist -qn QTH_SRC $$(grep -l Q_OBJECT *.$(H++_SUFFIX))

#
# todo: --Find "unfinished work" comments in QT files.
#
.PHONY: qt-todo
todo:	qt-todo
qt-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(QTH_SRC) $(QTR_SRC) /dev/null || true
