#!/bin/sh
#
# MK-AR-MERGE --Merge a collection of objects and archives into one.
#
#
usage="Usage: mk-ar-merge [options] [ar-flags] archive object+archive-files..."
tmpdir=${TMPDIR:-/tmp}/mk-ar$$
ar=${AR:-ar}
status=0

log_message() { printf "$@"; printf "\n"; } >&2
warning() { log_message "$@"; status=1; }
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
    local prefix=$(mung_lib_name $1) file= saved_pwd=$PWD

    log_cmd mkdir -p $tmpdir/$prefix
    log_cmd ln -s $PWD/$1 $tmpdir/$prefix/lib.a
    cd $tmpdir/$prefix;
    debug 'building library in "%s"' "$PWD"
    $ar x lib.a

    for file in *.o; do
	if [ -e $file ]; then
	    mv $file ../${prefix}-$file
	else
	    warning 'cannot archive file: "%s"' "$file"
	fi
    done
    cd $saved_pwd
    rm -rf $tmpdir/$prefix
}

while getopts "x:vq_" c
do
    case $c in
    x)  ar="$OPTARG";;
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
if $ar $ar_flags $library $tmpdir/*.o; then
    exit $status		# signal any failures
fi
