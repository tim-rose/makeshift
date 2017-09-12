#
# Makefile --build rules for midden's test directory
#
#
language = sh
SH_SRC = tap-api.sh tap-process.sh tap-protocol.sh
TAP_TESTS = $(SH_SRC:%.sh=%)
LOCAL.SH_LINT_FLAGS = -e SC2034
#SC2039,SC2059,SC2064,SC2154

include devkit.mk test/tap.mk
