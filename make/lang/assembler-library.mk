#
# C-LIBRARY.MK --Rules for managing libraries of C objects.
#
# Contents:
#
$(archdir)/lib.$(a):	$(AS_LIB_OBJ)
$(archdir)/lib.$(s.a):	$(AS_LIB_PIC_OBJ)
