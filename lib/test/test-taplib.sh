#!/bin/sh
. ../tap.shl
plan 5
ok 0
ok 0 success
nok 1 fail
ok_eq 0 0 success
#nok_eq 0 1 fail
ok_grep foobar foo success
#nok_grep foobar fox fail
