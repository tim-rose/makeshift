#
# C-LIBRARY.MK --Rules for managing libraries of C objects.
#
# Contents:
# pre-build-lib:       --Install headers into library root, via lib's pre-build.
# clean-lib:           --Remove the staged include files.
# install-lib-include-c: --Install a library's include files.
#
$(archdir)/lib.$(a):	$(AS_LIB_OBJ)
$(archdir)/lib.$(s.a):	$(AS_LIB_PIC_OBJ)
