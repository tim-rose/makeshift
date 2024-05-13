#!/bin/sh
#
# MK-VCS-GET --Get some components stored in a VCS.
#
# Contents:
# main()    --Parse options and process arguments
# vcs_get() --Get a single component specified by the config.
#
version="VERSION"
usage="Usage: mk-vcs-get [-f config] [-v] [-q] file..."
component_file=components.conf

log_message() { printf "$@"; printf "\n"; } >&2
notice() { log_message "$@"; }
info()   { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()  { if [ "$debug" ]; then log_message "$@"; fi; }

#
# main() --Parse options and process arguments
#
main()
{
    while getopts "f:vq_?" c
    do
        case $c in
        f)  component_file="$OPTARG";;
        v)  verbose=1;;
        q)  quiet=1;;
        _)  debug=1; verbose=1;;
        \?)	echo $usage >&2
            exit 2;;
        esac
    done
    shift $(($OPTIND - 1))

    for target in "$@"; do
        vcs_get "$target"
    done
}

#
# vcs_get() --Get a single component specified by the config.
#
vcs_get()
{
    local match= component= url=

    if match=$(grep "^$1:" "$component_file"); then 
        component=${match%%:*} 
        url=${match#*:}
        if [ ! -d "$component" ]; then 
            info '%s: download from %s' "$component" "$url"
            git clone "$url" "$component"
        else 
            info '%s: already installed' "$component"
        fi 
    else 
        notice '%s: unknown component' "$1"
    fi
}

main "$@"
