#!/bin/sh
#
# MK-INSTALL --A simple (portable, hopefully) subset of install(1).
#
# Remarks:
# This build system tries to be as portable as possible, within
# the constraint of being GNU-make based.  In any case, makeshift doesn't
# need all of install's bells and whistles, so this script implements
# only those bits makeshift actually uses.
#
#
usage="Usage: mk-install [options] files..."
permission=755

log_message() { printf "$@"; printf "\n"; } >&2
notice() { log_message "$@"; }
info()   { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()  { if [ "$debug" ]; then log_message "$@"; fi; }
log_cmd(){ debug "exec: $*"; "$@"; }
log_quit() { log_message "$@"; exit 1; }

install_file()
{
    cp "$1" "$2"
    chmod "$permission" "$2"
    if [ "$owner" -o "$group" ]; then
        chown "$owner:$group" "$2"
    fi
    if [ "$strip" ]; then
	strip "$2"
    fi
    if [ "$timestamp" ]; then
	touch -r "$1" "$2"
    fi
}

while getopts "bCDdg:m:o:svq_" c
do
    case $c in
    b)  backup=1;;
    C)  compare=; notice '-C is not implemented';;
    D)  mk_path=;;
    d)  dir_mode=1;;
    g)  group=$OPTARG;;
    m)  permission=$OPTARG;;
    o)  owner=$OPTARG;;
    s)  strip=1;;
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
        mkdir -p $item || loq_quit 'Failed to create directory "%s"' "$item"
        adjust_proprties $item $item || exit 1
    done
fi

dir=${2%/*}
if [ ! -d "$dir" -a "$mk_path" ]; then
    mkdir -p "$dir"
fi

if [ "$#" -eq 2 ]; then
    install_file "$1" "$2"
else
    arg_pos=0
    for target; do :; done	# get last arg
    if [ ! -d "$target" ]; then
	log_quit 'target "%s" is not a directory' "$target"
    fi
    for arg; do
	arg_pos=$(($arg_pos+1))
	if [ "$arg_pos" -eq "$#" ]; then
	    break
	fi
	install_file "$arg" "$target"
    done
fi
