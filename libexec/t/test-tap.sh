. ../tap.shl
plan 10
ok 0
ok 0 success
ok 1 fail
cmp 0 0 success
cmp 0 1 fail
ok_grep foobar foo success
ok_grep foobar fox success
