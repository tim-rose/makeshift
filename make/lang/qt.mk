#
# QT.MK --Rules for building Qt GUI applications
#
# Contents:
# build: --Build the Qt files
# clean: --Remove objects and intermediats created from Qt files.
# src:   --Update the QTH_SRC, QTR_SRC macros.
# todo:  --Find "unfinished work" comments in QT files.
#
#-include $(QTH_SRC:%.hpp=$(archdir)/%-depend.mk)
RCC	= rcc
MOC	= moc-qt4

QTR_TRG = $(QTR_SRC:%.qrc=$(archdir)/%.cpp)
QTH_TRG = $(QTH_SRC:%.hpp=$(archdir)/moc-%.cpp)
QT_TRG  = $(QTR_TRG) $(QTH_TRG)

QTR_OBJ = $(QTR_TRG:%.cpp=%.o)
QTH_OBJ = $(QTH_TRG:%.cpp=%.o)
QT_OBJ  = $(QTR_OBJ) $(QTH_OBJ)

#
# build: --Build the Qt files
#
build:	$(QT_OBJ)
$(archdir)/%.cpp:	%.qrc;	$(RCC) $? >$@
$(archdir)/moc-%.cpp:	%.hpp;	$(MOC) -o $@ $?

#
# clean: --Remove objects and intermediats created from Qt files.
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
	@mk-filelist -qn QTH_SRC $$(grep -l Q_OBJECT *.hpp)

#
# todo: --Find "unfinished work" comments in QT files.
#
.PHONY: qt-todo
todo:	qt-todo
qt-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(QTH_SRC) $(QTR_SRC) /dev/null || true
