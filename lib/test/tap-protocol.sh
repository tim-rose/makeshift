#!/bin/sh
#
# TAP-PROTOCOL.SH --Test that taplib outputs the TAP protocol.
#
. ../tap.shl
isatty=				# force tty stuff customisations off

#
# skip_prologue() --Skip the first 3 lines of prologue comments.
#
skip_prologue() { sed -e 1,3d; }

plan 6

plan_text=$( ( . ../tap.shl; plan 2; ok 0; ok 0; ) | skip_prologue | sed -ne1p)
ok_match "$plan_text" '1..[0-9]*' 'plan is the first non-comment line'
ok_eq "$plan_text" '1..2' 'plan identifies the number of planned tests'

plan_text=$( ( . ../tap.shl; ok 0; ok 0; plan; ) | skip_prologue | sed -ne '$p')
ok_eq "$plan_text" '1..2' 'plan can be defined at the end'

plan_text=$( ( . ../tap.shl; plan 3; ok 0; ) | skip_prologue | sed -ne '$p')
ok_eq "$plan_text" '# Looks like you planned 3 tests but ran 1.' \
      'plan mismatch (too few) is reported in epilogue'

plan_text=$( ( . ../tap.shl; plan 1; ok 0; ok 0; ) | skip_prologue | sed -ne '$p')
ok_eq "$plan_text" '# Looks like you planned 1 test but ran 2.' \
      'plan mismatch (too many) is reported in epilogue'

plan_text=$( ( . ../tap.shl; plan 2; ok 0; ok 1; ) | skip_prologue | sed -ne '$p')
ok_eq "$plan_text" '# Looks like you failed 1 test of 2 run.' \
      'test failures are summarised'
