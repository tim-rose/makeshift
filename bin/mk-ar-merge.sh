#!/bin/sh
#
# MK-AR-MERGE --Merge a collection of objects and archives into one.
#
#
usage="Usage: mk-ar-merge archive object+archive-files..."
tmpdir=${TMPDIR:-/tmp}/mk-ar$$

log_message() { printf "$@"; printf "\n"; } >&2
notice() { log_message "$@"; }
info()   { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()  { if [ "$debug" ]; then log_message "$@"; fi; }

ar_expand()
{
    local dir=.
    if [ "$1" = '-d' ]; then
	dir=$2; shift 2
    fi
    base=$(basename $1 .a | sed -e 's/lib//')
    echo "mkdir $dir/$base"
    mkdir -p $dir/$base
    (
	echo "ln -s $1 $dir/$base"
	ln -s $PWD/$1 $dir/$base
	cd $dir/$base;
	ar x $1
	for f in *.o; do
	    mv $f ../${base}_$f
	done
    )
    rm -rf $dir/$base
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

library=$1; shift

for file in $*; do
    if [ ! -f "$file" ]; then
	continue
    fi
    case "$file" in
	*.o) cp $file $tmpdir;;
	*.a) ar_expand -d $tmpdir $file;;
	*) notice "unrecognised file: \"$file\"";;
    esac
done

ar r $library $tmpdir/*.o
