#
# QT-LIBRARY.MK --Rules for managing libraries of QT objects.
#
# Contents:
# pre-build-lib: --Install headers into library root, via lib's pre-build.
# clean-lib:     --Remove the staged include files.
# install-lib-include-c++: --Install a library's include files.
#

$(archdir)/lib.a:	$(QT_OBJ)

#
# pre-build-lib: --Nothing to do?
#
.PHONY: pre-build-lib-qt
pre-build-lib: pre-build-lib-qt
pre-build-lib-qt:;$(ECHO_TARGET)

#
# clean-lib: --Nothing to do?
#
.PHONY: clean-lib-qt
clean-lib: clean-lib-qt
clean-lib-qt:;$(ECHO_TARGET)

#
# install-lib-include-qt: --Install a library's QT include files.
#
# Remarks:
# These targets customise the library.mk behaviour.
#
.PHONY: install-lib-include-qt
install-lib-include:	install-lib-include-qt
install-lib-include-qt:  $(QTH_SRC:%.$(H++_SUFFIX)=$(includedir)/%.$(H++_SUFFIX))
.PHONY: uninstall-lib-include-qt
uninstall-lib-include:	uninstall-lib-include-qt
uninstall-lib-include-qt:; $(RM) $(QTH_SRC:%=$(includedir)/%)
