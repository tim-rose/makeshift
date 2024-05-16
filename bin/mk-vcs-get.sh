#!/bin/sh
#
# MK-VCS-GET --Get some components stored in a VCS.
#
# Contents:
# main()         --Parse options and process arguments
# git_download() --Download a single component specified by the config.
# git_info()     --Print some useful information about a repo.
#
# Remarks:
# Only handles git.
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
        git_download "$target"
    done
}

#
# git_download() --Download a single component specified by the config.
#
git_download()
{
    local match= dir= url= tag=

    if match=$(grep "^$1:" "$component_file"); then 
        dir=${match%%:*} 
        url=${match#*:}
        tag=${url#*,}
        url=${url%%,*}

        if [ ! -d "$dir" ]; then 
            info '%s: download from %s' "$dir" "$url"
            git clone "$url" "$dir"
            if [ "$url" != "$tag" ]; then
                info '%s: checkout %s' "$dir" "$tag"
                ( cd "$dir" && git checkout "$tag"; )
            fi
        fi 
        git_info "$dir"
    else 
        notice '%s: unknown component' "$1"
    fi
}

#
# git_info() --Print some useful information about a repo.
#
git_info()
(
    local dir="$1"
    cd "$dir" || exit
    local url=$(git config --list | 
        sed -ne '/^remote.origin.url/s/.*=//p')
    local info=$(
        git describe --always --first-parent --dirty 2>/dev/null || 
        echo unknown)

    info "%s: %s %s" "$dir" "$url" "$info"
)

main "$@"
