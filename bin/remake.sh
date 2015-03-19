#!/bin/sh
#
# REMAKE --Watch some files, and run a "make" command when they change.
#
usage="Usage: remake [-c command] [-t target] [-d delay] files..."

log_message() { printf "remake: "; printf "$@"; printf "\n"; } >&2
notice()      { log_message "$@"; }
info()        { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()       { if [ "$debug" ]; then log_message "$@"; fi; }
log_quit()    { notice "$@"; exit 1 ; }

command=make
target=
delay=10
#
# process command-line options
#
while getopts "c:d:t:vq_" c
do
    case $c in
    c)  command=$OPTARG;;
    d)  delay=$OPTARG;;
    t)  target=$OPTARG;;
    v)  verbose=1; debug=;;
    q)  verbose=; debug=;;
    _)  verbose=1; debug=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

if [ $# -le 0 ]; then
    log_quit 'no files'
fi

now=0
changed=
while :; do
    debug '%d: reference' $now
    for file; do		# REVISIT: bulk compare with ls(1) output
	if [ ! -e "$file" ]; then
	    continue		# bad wildcard?
	fi
        mtime=$(stat -c '%Y' "$file")
        debug '%d: %s' $mtime "$file"

        if [ $mtime -gt $now ]; then
            info '"%s" has changed' "$file"
            changed="$changed $file"
        fi
    done
    if [ "$changed" ]; then
        $command $target
        now=$(date '+%s')
    fi
    debug 'waiting %d seconds' $delay
    sleep $delay
done
