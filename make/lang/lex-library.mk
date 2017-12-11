#
# LEX-LIBRARY.MK --Rules for libraries with LEX objects.
#
# Contents:
# install-lib-include-lex: --Install a library's include files.
#

$(archdir)/lib.$(a):	$(LEX_OBJ)
$(archdir)/lib.$(sa):	$(LEX_PIC_OBJ)

#
# install-lib-include-lex: --Install a library's include files.
#
# Remarks:
# These targets customise the library.mk behaviour.
#
.PHONY: install-lib-include-lex
install-lib-include:	install-lib-include-lex
install-lib-include-lex:  $(LEX_SRC:%.l=$(includedir)/%.h)
.PHONY: uninstall-lib-include-lex
uninstall-lib-include:	uninstall-lib-include-lex
uninstall-lib-include-lex:; $(RM) $(LEX_SRC:%=$(includedir)/%)
