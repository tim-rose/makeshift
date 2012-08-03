#!/bin/sh
#
# SVN-IMPORT --import a directory into the SVN repository
#
# Remarks:
# This script automates the creation/manipulation of the
# initial directory structures for an SVN project.  It's
# a little hokey, but it gets the job done.
# REVISIT: rewrite this in perl?
# 
svn=$SVN_ROOT
verbose=0
while getopts 's:' c; do
    case $c in
    s)	svn=$OPTARG;;
    v)	verbose=1;;
    \?) echo "Usage: svn-import <directory>..." >&2; exit 2;;
    esac
done
shift $(expr $OPTIND - 1)

if [ ! "$svn" ]; then
    echo "SVN_ROOT is not defined!" >&2
    exit 1
fi

for d in $*; do
    d=$(echo $d | sed -e's@/$@@') # strip trailing "/" from directory name

    mv $d $d.trunk		# create trunk, skeleton tags, branches
    mkdir $d $d/tags $d/branches
    mv $d.trunk $d/trunk

    svn import -m "Initial import of $d" $d $svn/$d
    mv $d $d.orig
    svn co $svn/$d/trunk $d	# checkout with elided trunk
done
exit 0
