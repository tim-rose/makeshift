#!/bin/sh
#
# TEST-TAPLIB.SH --Test taplib.
#
. ../tap.shl

#
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

plan 9
ok 0
ok 0 success
nok 1 fail
ok_eq 0 0 'eq success'
nok_eq 0 1 'eq fail'
ok_match foobar 'foo*' 'glob success'
nok_match foobar 'fox*' 'glob fail'
ok_grep foobar 'fo*bar' 'regex success'
nok_grep foobar 'fo[x]bar' 'regex fail'
