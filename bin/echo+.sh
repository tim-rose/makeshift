#!/bin/sh
#
# echo+ --extended echo command
#
# Remarks:
# This script is useful for mocking up behaviour in testing.
#
log_message() { printf "$@"; printf "\n"; } >&2
notice() { log_message "$@"; }
info()   { if [ "$verbose" ]; then log_message "$@"; fi; }

delay=
signal=
status=0
verbose=
usage="Usage:\necho+ [-d delay] [-e stderr-message] [-s signal] [-x status] message"

while getopts "d:e:s:x:v" c; do
    case $c in
    d)	delay=$OPTARG;;
    e)	echo $OPTARG >&2;;
    s)	signal=$OPTARG;;
    x)	status=$OPTARG;;
    v)	verbose=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

if [ "$delay" ]; then
    info 'sleeping for %ds' "$delay"
    sleep $delay
fi

echo "$@"

if [ "$signal" ]; then
    info 'sending %s signal to %s...' "$signal" "$$"
    kill -s $signal $$
fi
exit $status
