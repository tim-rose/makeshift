#
# C-LIBRARY.MK --Rules for managing libraries of C objects.
#
# Contents:
# pre-build-lib:       --Install headers into library root, via lib's pre-build.
# clean-lib:           --Remove the staged include files.
# install-lib-include-c: --Install a library's include files.
#
$(archdir)/lib.a:	$(C_OBJ)

#
# pre-build-lib: --Install headers into library root, via lib's pre-build.
#
# Remarks:
# library.mk defines LIB_INCLUDEDIR, and pre-build-lib.
#
.PHONY: pre-build-lib-c
pre-build-lib: pre-build-lib-c
pre-build-lib-c: $(H_SRC:%=$(LIB_INCLUDEDIR)/%)

#
# clean-lib: --Remove the staged include files.
#
.PHONY: clean-lib-c
clean-lib: clean-lib-c
clean-lib-c:; $(RM) $(H_SRC:%=$(LIB_INCLUDEDIR)/%)

#
# install-lib-include-c: --Install a library's include files.
#
# Remarks:
# These targets customise the library.mk's (un)install-lib-include target.
#
.PHONY: install-lib-include-c
install-lib-include:	install-lib-include-c
install-lib-include-c:  $(H_SRC:%.h=$(includedir)/%.h)

.PHONY: uninstall-lib-include-c
uninstall-lib-include:	uninstall-lib-include-c
uninstall-lib-include-c:; $(RM) $(H_SRC:%=$(includedir)/%)
