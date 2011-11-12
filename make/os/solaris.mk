#
# SOLARIS.MK	--Macros and definitions for Solaris/sparc.
#
C_OS_DEFS = -D__solaris__
CXX_OS_DEFS = -D__solaris__

GREP		= grep

SUMMARISE_TESTS	= prove --perl cat
