#!/bin/sh
#
# TEST-API.SH --Test the extended assertions in test-more.
#
PATH=..:$PATH
. tap.shl

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

plan 23

pass 'pass: success'
todo 'expected failure' fail 'fail: failure'

ok 0            # no-args is OK
ok 0 'ok: success'
todo 'expected failure' ok 1 'ok: failure'

nok 1 fail 'nok: success'
todo 'expected failure' nok 1 fail 'nok: failure'

ok_eq blah blah 'eq: success'
todo 'expected failure' ok_eq black white 'eq: failure'

is 0 0 'is() is an alias for ok_eq()'
todo 'expected failure' is 0 1 'is() is an alias for ok_eq()'

ok_neq good bad 'neq: success'
todo 'expected failure' ok_neq good good 'neq: failure'

ok_match foobar 'foo*' 'ok_match(): success (does a glob match)'
todo 'expected failure' ok_match foobar 'zoo*' 'ok_match(): failure'

nok_match foobar 'fox*' 'nok_match() does a glob mismatch'
matches foobar 'foo*' 'matches() is an alias for ok_match()'
todo 'expected failure' matches foobar 'zoo*' 'match failure'

ok_grep foobar 'fo*bar' 'ok_grep() matches a regex'
todo 'expected failure' ok_grep foobar 'fo[x]bar' 'match failure'
nok_grep foobar 'fo[x]bar' 'nok_grep() does a regex mismatch'
like foobar 'fo*bar' 'like() is an alias for ok_grep()'
unlike foobar 'fo[x]bar' 'unlike() is an alias for nok_grep()'
