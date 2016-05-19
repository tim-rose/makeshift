#!/bin/sh
#
# TEST-TAPLIB.SH --Test taplib.
#
. ../tap.shl

#
# Protocol tests:
# * prologue timestamp
# * prologue plan
# * epilogue failure summary
# * epilogue plan mismatch
# API tests:
# * plan none, 0, 1, ...
# * ok true/false
# * nok true/false
# * ok_eq
#   * true/false
#   * have/expected
# * ok_match
# * ok_grep
# * todo
# * diag
#

plan 5
ok 0
ok 0 success
nok 1 fail
ok_eq 0 0 success
#nok_eq 0 1 fail
ok_grep foobar foo success
#nok_grep foobar fox fail
