#!/bin/sh
#
# MK-INSTALL --A simple (portable, hopefully) subset of install(1).
#
# Remarks:
# This build system tries to be as portable as possible, within
# the constraint of being GNU-make based.  In any case, devkit doesn't
# need all of install's bells and whistles, so this script implements
# only those bits devkit actually uses.
#
#
usage="Usage: mk-install [options] files..."

log_message() { printf "$@"; printf "\n"; } >&2
notice() { log_message "$@"; }
info()   { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()  { if [ "$debug" ]; then log_message "$@"; fi; }
log_cmd(){ debug "exec: $*"; "$@"; }
log_quit() { log_message "$@"; exit 1; }

adjust_permission()
{
    if [ "$permission" ]; then
        chmod "$permission" "$1"
    fi 
}

while getopts "Ddm:vq_" c
do
    case $c in
    d)  dir_mode=1;;
    D)  mk_path=;;
    m)  permission=$OPTARG;;
    v)  verbose=1;;
    q)  quiet=1;;
    _)  debug=1; verbose=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

if [ "$dir_mode" ]; then
    for item in $*; do
        mkdir -p $item || 
            loq_quit 'Failed to create directory "%s"' "$item"
        adjust_permission $item || 
            log_quit 'Failed to set permissions for "%s"' $item
    done
else
    log_quit "not implemented"
fi
