#!/bin/sh
usage="Usage: remake [-c command] files..."

log_message() { printf "remake: "; printf "$@"; printf "\n"; } >&2
notice()      { log_message "$@"; }
info()        { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()       { if [ "$debug" ]; then log_message "$@"; fi; }
log_quit()    { notice "$@"; exit 1 ; }

command=make
delay=10
#
# process command-line options
#
while getopts "c:d:vq_" c
do
    case $c in
    c)  command=$OPTARG;;
    d)  delay=$OPTARG;;
    v)  verbose=1; debug=;;
    q)  verbose=; debug=;;
    _)  verbose=1; debug=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

now=0
while :; do
    debug '%d: reference' $now
    for file; do
        mtime=$(stat -c '%Y' "$file")
        debug '%d: %s' $mtime "$file"
        if [ $mtime -gt $now ]; then
            info '"%s" has changed' "$file"
            $command
            now=$(date '+%s')
            break
        fi
    done
    debug 'waiting %d seconds' $delay
    sleep $delay
done
