#!/bin/sh
#
# MK-AR-MERGE --Merge a collection of objects and archives into one.
#
#
usage="Usage: mk-ar-merge [options] [ar-flags] archive object+archive-files..."
tmpdir=${TMPDIR:-/tmp}/mk-ar$$

log_message() { printf "$@"; printf "\n"; } >&2
notice() { log_message "$@"; }
info()   { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()  { if [ "$debug" ]; then log_message "$@"; fi; }
log_cmd(){ debug "exec: $*"; "$@"; }

#
# mung_lib_name() --convert "foo/bar/libxyzzy.a" to "foo-bar-xyzzy".
#
mung_lib_name()
{
    echo $* |
        sed -e 's/lib//' -e 's/\.a//' -e 's/\//-/g' \
	    -e "s/${OS:-^}/-/" -e "s/${ARCH:-^}/-/" \
	    -e 's/--*/-/g' -e 's/-$//g'
}

#
# expand_ar() --Extract all of a library's objects in a uniform way.
#
expand_ar()
{
    local prefix=$(mung_lib_name $1)

    log_cmd mkdir -p $tmpdir/$prefix
    (
	log_cmd ln -s $PWD/$1 $tmpdir/$prefix/lib.a
	cd $tmpdir/$prefix;
	debug 'building library in "%s"' "$PWD"
	ar x lib.a
	for f in *.o; do
	    mv $f ../${prefix}-$f
	done
    )
    rm -rf $tmpdir/$prefix
}

while getopts "vq_" c
do
    case $c in
    v)  verbose=1;;
    q)  quiet=1;;
    _)  debug=1; verbose=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

trap "rm -rf $tmpdir" 0 		# cleanup
mkdir -p $tmpdir

ar_flags=$1; shift
library=$1; shift

for file; do
    if [ ! -e "$file" ]; then
	continue
    fi
    case "$file" in
	*.o) cp $file $tmpdir;;
	*.a) expand_ar $file;;
	*) notice "unrecognised file: \"$file\"";;
    esac
done

mkdir -p $(dirname $library)
ar $ar_flags $library $tmpdir/*.o
