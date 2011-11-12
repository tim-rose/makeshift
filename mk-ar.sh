#!/bin/sh
#
# MK-ARCHIVE --Make a BSD style archive.
#
# Remarks:
# This is a simple script to build "BSD" style archives, which are
# required/expected by the Debian package toolchain.  Note that
# we only need to create archives, because the GNU ar can read
# them OK.  Mysteriously, Debian doesn't provide a standalone
# command for this.
#
usage="Usage: mk-archive file..."

log_message() { printf "$@"; printf "\n"; } >&2
notice() { log_message "$@"; }
info()   { if [ "$verbose" -o "$debug" ]; then log_message "$@"; fi; }
debug()  { if [ "$debug" ]; then log_message "$@"; fi; }

while getopts "vq_" c
do
    case $c in
    v)  verbose=1;;
    q)  quiet=1;;
    _)  debug=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

echo '!<arch>'
for file in $*; do
    info '%s' $file
    stat --format '%Y %u %g %f %s' $file |
    while read mtime uid gid mode size; do
	printf '%-16s%-12d%-6d%-6d%-8o%-10d`\n' \
	    $file $mtime $uid $gid 0x$mode $size
    done
    cat $file
    size=$(stat --format='%s' $file)
    if [ $(($size % 2)) -ne 0 ]; then
	echo ''			# pad to even bytes
    fi
done
