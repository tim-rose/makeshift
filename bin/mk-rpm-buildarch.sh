#!/bin/sh
#
# MK-RPM-BUILDARCH --Echo the RPM's value of "Buildarch".
#
# Remarks:
# RPM has a default value for Buildarch based on the current system's
# arch, but this script sniffs the ".spec" file to see if it's been
# overridden (e.g. for "noarch" packages).
#
rpm_arch()
{
    local file=$1
    if [ "$file" -a -f "$file" ]; then
	if grep ^Buildarch: "$file" >/dev/null 2>&1; then
	    sed -ne 's/^Buildarch: *//p' "$file"
	else
	    rpm --eval "%{_arch}"
	fi
    else
	rpm --eval "%{_arch}"
    fi
}

main()
{
    if type rpm >/dev/null 2>&1; then
	rpm_arch $1
    else
	uname -m | tr A-Z a-z
    fi
}

main "$@"
