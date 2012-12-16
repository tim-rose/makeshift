#!/bin/sh
#
# SKEL.SH --Copy some skeleton files into the current directory.
#
# Contents:
#
# Remarks:
# This is still in stream-of-conciousness mode.  It doesn't work yet.
#
# TODO: get this to a basic working state!
#
usage="Usage: skel [options] type..."
skel_root=$DEVKIT_HOME/skel
log_message() { printf "$@"; printf "\n"; } >&2
err()         { log_message "$@"; }
notice()      { log_message "$@"; }
info()        { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()       { if [ "$debug" ]; then log_message "$@"; fi; }
log_quit()    { notice "$@"; exit 1 ; }

#
# process command-line options
# -r alternate skel_root?
# -t "template" replacement text
#
while getopts "vq_" c
do
    case $c in
    v)  verbose=1; debug=;;
    q)  verbose=; debug=;;
    _)  verbose=1; debug=1;;
    \?)	err "$usage"; exit 2;;
    esac
done
shift $(($OPTIND - 1))

if [ $# -lt 1 ]; then
    err "$usage"; exit 2   
fi

#
# something like...
#
for type; do 
    info 'copying %s files...' "$type"
# preserve permissions
# replace "template" text with some real stuff (default dirname/base)
# replace "template" in file name to real stuff.
    ( cd $skel_root && tar cf - $type ) | tar xvf -
done
