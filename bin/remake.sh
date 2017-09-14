#!/bin/sh
#
# REMAKE --Watch some files, and run a "make" command when any change.
#
# Contents:
# main()        --loop forever, checking for file changes.
# duration()    --Format a duration in seconds to <x>m<y>s.
# find_change() --Find a file that has changed since some timestamp.
#
usage="Usage: remake [-c command] [-o options] [-t target] [-d delay] files..."

log_message() { printf "remake: "; printf "$@"; printf "\n"; } >&2
notice()      { log_message "$@"; }
info()        { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()       { if [ "$debug" ]; then log_message "$@"; fi; }
log_quit()    { notice "$@"; exit 1; }
log_cmd()     { debug "exec: $*"; "$@"; }

command="make"
target=build
delay=10

#
# main() --loop forever, checking for file changes.
#
main()
{
    local now=0	changed='' start='' build=1 status=''

    while :; do
	debug '%d: reference' $now

	changed=$(find_change "$now" "$@")
	if [ "$changed" ]; then
	    info '%s: %s' "$target" "$changed"

	    start=$(date '+%s')
            if log_cmd $command $opts $target; then
		status='succeeded'
	    else
		status='failed'
	    fi
            now=$(date '+%s')

	    notice 'build %d %s after %s' \
		   "$build" "$status" "$(duration $((now-start)))"
	    build=$((build+1))
	fi

	debug 'waiting %ds' "$delay"
	sleep "$delay"
    done
}

#
# duration() --Format a duration in seconds to <x>m<y>s.
#
duration()
{
    local min=$(($1/60)) sec=$(($1%60))
    if [ "$min" -gt 0 ]; then
	printf '%dm' "$min"
    fi
    printf '%ds\n' "$sec"
}

#
# find_change() --Find a file that has changed since some timestamp.
#
# Parameters:
# $1 --the timestamp
# $* --the list of files to check
#
# Output:
# Sucess: the name of a file that changed; Failure; "".
#
find_change()
{
    local now=$1 mtime=
    shift

    for file; do
	if [ ! -e "$file" ]; then
	    debug "\"%s\" doesn't exist" "$file"
	    echo "$file"
	    break
	fi

        mtime=$(stat -c '%Y' "$file")
        debug '%d: %s' $mtime "$file"

        if [ $mtime -gt $now ]; then
	    debug '"%s" has changed' "$file"
	    echo "$file"
	    break
        fi
    done
}

#
# process command-line options
#
while getopts "c:d:t:o:vq_" c
do
    case $c in
    c)  command=$OPTARG;;
    d)  delay=$OPTARG;;
    o)  opts=$OPTARG;;
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

main "$@"
