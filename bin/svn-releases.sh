#!/bin/sh
#
# SVN-RELEASES.SH --get a sorted list of releases for a package.
#
PATH=$PATH:/usr/libexec:/usr/local/libexec
. log.shl

svn=$SVN_ROOT
url=
while getopts 's:' c; do
    case $c in
    s)	svn=$OPTARG;;
    \?) echo "Usage: svn-import <directory>..." >&2; exit 2;;
    esac
done
shift $(expr $OPTIND - 1)

if [ ! "$svn" ]; then
    echo "SVN_ROOT is not defined!" >&2
    exit 1
fi

if [ $# -ne 0 ]; then
    if ! svn info $svn/$1 >/dev/null 2>&1; then
	err "not a valid package: %s" $1
	exit 1
    fi
    url=$svn/$1
elif svn status >/dev/null; then # default to current directory
    url=$(svn info |
	sed -ne '/^URL:/s/URL: //p' |
	sed -e 's|/trunk$||' -e 's|/branches/.*$||')
else
    exit 1
fi
info "url: %s" $url
svn ls $url/tags |
    sed -e 's|/||' |
    sort -n -t. -k 1,1 -k 2,2 -k 3,3 | # sort by major.minor.patch
    sed -e "s|^|$url/tags/|"
