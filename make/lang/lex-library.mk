#
# LEX-LIBRARY.MK --Rules for libraries with LEX objects.
#
# Contents:
# pre-build-lib:       --Install headers into library root, via lib's pre-build.
# clean-lib:           --Remove the staged include files.
# install-lib-include-lex: --Install a library's include files.
#

#
# install-lib-include-lex: --Install a library's include files.
#
# Remarks:
# These targets customise the library.mk behaviour.
#
.PHONY: install-lib-include-lex
install-lib-include:	install-lib-include-lex
install-lib-include-lex:  $(LEX_SRC:%.y=$(includedir)/%.h)
.PHONY: uninstall-lib-include-lex
uninstall-lib-include:	uninstall-lib-include-lex
uninstall-lib-include-lex:; $(RM) $(LEX_SRC:%=$(includedir)/%)
