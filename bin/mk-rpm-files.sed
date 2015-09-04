#!/usr/bin/env sed -f
#
# MK-RPM-FILES --Mung a list of files for use as a RPM "files" section.
#
# wrap the filename in quotes, to protect against spaces:
s/.*/"&"/
# identify documentation files:
/man[0-9]/s/^/%doc /
/\.txt/s/^/%doc /
/\.pdf/s/^/%doc /
# identify config files:
/\.conf/s/^/%config /
/\.cfg/s/^/%config /
/\.ini/s/^/%config /
