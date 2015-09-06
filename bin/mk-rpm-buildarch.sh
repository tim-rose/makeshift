#!/bin/sh
#
# MK-RPM-BUILDARCH --Echo the RPM's value of "Buildarch".
#
# Remarks:
# RPM has a default value for Buildarch based on the current system's
# arch, but this script sniffs the ".spec" file to see if it's been
# overridden (e.g. for "noarch" packages).
#
if [ "$1" -a -f "$1" ]; then
    if grep ^Buildarch: "$1" >/dev/null 2>&1; then
	sed -ne 's/^Buildarch: *//p' "$1"
    else
	rpm --eval "%{_arch}"
    fi
else
    rpm --eval "%{_arch}"
fi
