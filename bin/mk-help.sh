#!/bin/sh
#
# MK-HELP --Extract/construct some help text from a list of makefiles.
#
#
usage="Usage: mk-help [options] makefiles..."
tmpdir=${TMPDIR:-/tmp}/mk-help$$

log_message() { printf "$@"; printf "\n"; } >&2
notice() { log_message "$@"; }
info()   { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()  { if [ "$debug" ]; then log_message "$@"; fi; }
log_cmd(){ debug "exec: $*"; "$@"; }

while getopts "vq_" c
do
    case $c in
    v)  verbose=1;;
    q)  quiet=1;;
    _)  debug=1; verbose=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

trap "rm -rf $tmpdir" 0 		# cleanup
mkdir -p $tmpdir

echo "# devkit help"
for file; do
    tmpfile=$tmpdir/help.txt
    sed -e '1,/# Remarks:/d' -e '/^[^#]/,$d' -e '/^$$/,$d' \
	-e 's/^# //' -e 's/^# *$//' <$file >$tmpfile
    if [ -s "$tmpfile" ]; then
	echo "## $(basename $file .mk)"
	cat $tmpfile
    fi
done
