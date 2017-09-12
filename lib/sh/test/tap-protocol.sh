#!/bin/sh
#
# TAP-PROTOCOL.SH --Test that taplib outputs the TAP protocol.
#
PATH=..:$PATH
. tap.shl

#
# skip_prologue() --Skip the first 3 lines of prologue comments.
#
skip_prologue() { sed -e 1,3d; }

#
# run_tests() --Run the specified tests in a sub-shell.
#
run_tests()
{
    (
	TAP_COLORS=ok=		# reset colourful logging...
	ok_style='' fail_style='' plan_style='' diag_style=''
	. tap.shl
	eval "$@"
    ) | skip_prologue
}

plan 7

tap_text=$(run_tests "ok 0; ok 0" | tail -1)
ok_eq "$tap_text" '# Tests were run but no plan was declared.' 'warn if no plan'

tap_text=$(run_tests "plan 2; ok 0; ok 0" | head -1)
ok_match "$tap_text" '1..[0-9]*' 'plan is the first non-comment line'
ok_eq "$tap_text" '1..2' 'plan identifies the number of planned tests'

tap_text=$(run_tests "ok 0; ok 0; plan" | tail -1)
ok_eq "$tap_text" '1..2' 'plan can be defined at the end'

tap_text=$(run_tests "plan 3; ok 0" | tail -1)
ok_eq "$tap_text" '# Looks like you planned 3 tests but ran 1.' \
      'plan mismatch (too few) is reported in epilogue'

tap_text=$(run_tests "plan 1; ok 0; ok 0" | tail -1)
ok_eq "$tap_text" '# Looks like you planned 1 test but ran 2.' \
      'plan mismatch (too many) is reported in epilogue'

tap_text=$(run_tests "plan 2; ok 0; ok 1" | tail -1)
ok_eq "$tap_text" '# Looks like you failed 1 test of 2 run.' \
      'test failures are summarised'
