#!/bin/sh
#
# MK-DEB-BUILDARCH --Echo the debian value of "Architecture".
#
# Remarks:
# By default the package will build a package for the current system
# arch, but this script sniffs the control file to see if it's been
# overridden (e.g. for "all" packages).
#
version="VERSION"
if [ "$1" -a -f "$1" ]; then
    if grep ^Architecture: "$1" >/dev/null 2>&1; then
	sed -ne 's/^Architecture: *//p' "$1"
    else
	echo $ARCH
    fi
else
    echo $ARCH
fi
