#!/bin/sh
#
# echo+ --extended echo command
#
# Remarks:
# This script is useful for mocking up behaviour in testing.
#
error=""
signal=""
status=0
verbose=0
opts="e:s:x:v"
usage="Usage:\necho+ [-e stderr-message] [-s signal] [-x status] message"

while getopts $opts c
do
    case $c in
    e)	echo $OPTARG >&2;;
    s)	signal=$OPTARG;;
    x)	status=$OPTARG;;
    v)	verbose=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift `expr $OPTIND - 1`
echo $*
if [ "$signal" != "" ]; then
    test $verbose -eq 0 || echo "sending signal $signal to self..."
    kill -s $signal $$
fi
exit $status
