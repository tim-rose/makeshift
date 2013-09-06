#!/bin/sh
#
# AR-MERGE --Merge ".a" format archives
#
# Remarks:
#
usage="Usage: ar-merge file.a file2.a..."

tmp=${TMPDIR:-/tmp}/$$
trap "rm -rf $tmp" 0
mkdir $tmp

log_message()
{
    if [ ! "$quiet" ]; then
	printf "ar-merge: ";
	printf "$@";
	printf "\n";
    fi
} >&2
notice()      { log_message "$@"; }
info()        { if [ "$verbose" -o "$debug" ]; then log_message "$@"; fi; }
debug()       { if [ "$debug" ]; then log_message "$@"; fi; }


while getopts "vq_" c
do
    case $c in
    v)  verbose=1;;
    q)  quiet=1;;
    _)  debug=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

if [ $# -eq 0 ]; then
    info 'no files'
    exit 2
fi

main_lib=$1; shift
if [ ! -f "$main_lib" ]; then
    notice "%s: target archive doesn't exist" "$main_lib"
    exit 1
fi

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

cp $main_lib $tmp
tmp_main_lib=$(basename $main_lib)
for lib; do
    if [ -f $lib ]; then
	debug 'importing %s' $lib
    else
	info '%s: no such file' $lib
	continue
    fi
    cp $lib $tmp
    tmp_lib=$(basename $lib)
    (
	cd $tmp
	ar x $tmp_lib $(ar t $tmp_lib| grep '.*\.o')
	prefix=$(mung_lib_name $lib)
	for obj in *.o; do
	    mv $obj $prefix-$obj
	done
	ar -r $tmp_main_lib *.o
	rm *.o
    )
done
cp $tmp/$tmp_main_lib $main_lib
exit 0
