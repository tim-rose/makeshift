#
# YACC-LIBRARY.MK --Rules for libraries with YACC objects.
#
# Contents:
# pre-build-lib:       --Install headers into library root, via lib's pre-build.
# clean-lib:           --Remove the staged include files.
# install-lib-include-yacc: --Install a library's include files.
#

#
# pre-build-lib: --Install headers into library root, via lib's pre-build.
#
# Remarks:
# library.mk defines LIB_INCLUDEDIR, and pre-build-lib.
#
.PHONY: pre-build-lib-yacc
pre-build-lib: pre-build-lib-yacc
pre-build-lib-yacc: $(YACC_H:%=$(LIB_INCLUDEDIR)/%)

#
# clean-lib: --Remove the staged include files.
#
.PHONY: clean-lib-yacc
clean-lib: clean-lib-yacc
clean-lib-yacc:; $(RM) $(YACC_H:%=$(LIB_INCLUDEDIR)/%)

#
# install-lib-include-yacc: --Install a library's include files.
#
# Remarks:
# These targets customise the library.mk behaviour.
#
.PHONY: install-lib-include-yacc
install-lib-include:	install-lib-include-yacc
install-lib-include-yacc:  $(YACC_SRC:%.y=$(includedir)/%.h)
.PHONY: uninstall-lib-include-yacc
uninstall-lib-include:	uninstall-lib-include-yacc
uninstall-lib-include-yacc:; $(RM) $(YACC_SRC:%=$(includedir)/%)
