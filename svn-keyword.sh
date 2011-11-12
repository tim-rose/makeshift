#!/bin/sh
#
# SVN-KEYWORD --Alter a file to use SVN tags.
# 
#
# Usage:
# svn-keyword files...
#
# Remarks:
# This is a once-off hack to finish converting the old CVS repository
# to SVN keywords.
#
IFS='!'
for f in $*; do
    if [ -d $f ]; then
	echo "svn-keyword: skipping directory $f" >&2
    else
	mv "$f" "$f.bak"		# create a backup!
	sed	-e 's/\$Header:[^$]*/$Id/' \
	    -e 's/\$Name:[^$]*\$//' \
	    -e 's/\$Locker:[^$]*\$//' \
	    -e 's/\$Log:[^$]*\$//' \
	    -e 's/\$RCSfile:[^$]*/$URL/' \
	    -e 's/\$Source:?[^$]*\$/$URL\$/' \
	    -e 's/\$Source\$/$URL\$/' \
	    -e 's/\$State:[^$]*\$//' <"$f.bak" >"$f"
	svn pset svn:keywords 'Date Revision Author URL Id' "$f"
    fi
done
