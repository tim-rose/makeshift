#!/bin/sh
#
# SVN-IMPORT --import a directory into the SVN repository
#
# Remarks:
# This script automates the creation/manipulation of the
# initial directory structures for an SVN project. It creates
# the typical top-level directories trunk, branches, tags.
#
log_message() { printf "$@"; printf "\n"; } >&2
notice() { log_message "$@"; }
info()   { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()  { if [ "$debug" ]; then log_message "$@"; fi; }
log_cmd() { debug "%s" "$*"; "$@"; }

svn=$SVN_ROOT
status=0

while getopts 's:vq_' c; do
    case $c in
    s)	svn=$OPTARG;;
    v)  verbose=1;;
    q)  quiet=1;;
    _)  debug=1; verbose=1;;
    \?) echo "Usage: svn-import <directory>..." >&2; exit 2;;
    esac
done
shift $(($OPTIND - 1))

if [ ! "$svn" ]; then
    notice "SVN_ROOT is not defined!"
    exit 1
fi

for d in $*; do
    d=${d%%/}		      # strip trailing "/" from directory name

    if ! svn ls $svn >/dev/null 2>&1; then
	notice "repository \"%s\" doesn't exist" "$svn"
	status=1
	continue
    fi
    log_cmd mv $d $d.trunk		# create trunk, skeleton tags, branches
    log_cmd mkdir $d $d/tags $d/branches
    log_cmd mv $d.trunk $d/trunk

    log_cmd svn import -m "Initial import of $d" $d $svn/$d
    log_cmd mv $d $d.orig
    log_cmd svn co $svn/$d/trunk $d	# checkout with elided trunk
done
exit $status
