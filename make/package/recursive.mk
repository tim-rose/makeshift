#
# package/recursive.mk --Recursive definitions for packaging.
#
# Remarks:
# By default, the "package" target is defined, but not recursive.
# Including this file makes it recursive in the normal way.
#
$(eval $(call recursive_rule,package,0))
