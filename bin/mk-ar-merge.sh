#!/bin/sh
#
# MK-AR-MERGE --Merge a collection of objects and archives into one.
#
# Contents:
# main()          --Process options, collect files into a library.
# mung_lib_name() --Convert "foo/bar/libxyzzy.a" to "foo-bar-xyzzy".
# expand_ar()     --Extract all of a library's objects in a uniform way.
#
# Remarks:
# This command takes a list of object files and/or libraries, and merges
# them into a single library file.
#
# TODO: add support for the MS toolchain.
#
usage="Usage: mk-ar-merge [options] [ar-flags] archive object+archive-files..."
tmpdir="${TMPDIR:-/tmp}/mk-ar$$"
ar=${AR:-ar}
ar_flags=
status=0
archdir=${archdir:-${OS}-${ARCH}} # hopefully already defined...
o=o     # object file extension
a=a     # library file extension

log_message() { printf "$@"; printf "\n"; } >&2
warning() { log_message "$@"; status=1; }
notice() { log_message "$@"; }
info()   { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()  { if [ "$debug" ]; then log_message "$@"; fi; }
log_cmd(){ debug "exec: $*"; "$@"; }

#
# main() --Process options, collect files into a library.
#
main()
{
    while getopts "a:o:r:x:vq_" c
    do
	case $c in
	    a)  a="$OPTARG";;
	    o)  o="$OPTARG";;
	    r)  ar_flags="-r";;
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
    mkdir -p "$tmpdir"

#    ar_flags="$1"; shift
    library="$1"; shift

    for file; do
	if [ ! -e "$file" ]; then
	    continue
	fi
	case "$file" in
	    *.$o) cp "$file" "$tmpdir";;
	    *.$a) expand_ar "$file";;
	    *) notice 'unrecognised file: "%s"' "$file";;
	esac
    done

    mkdir -p $(dirname "$library")
    log_cmd $ar $ar_flags "$library" $tmpdir/*.o 2>/dev/null
    true                # discard failures
}

#
# mung_lib_name() --Convert "foo/bar/libxyzzy.a" to "foo-bar-xyzzy".
#
# Remarks:
# This routine uses sed to process the path:
# * strip_lib --strip the library name punctuation ("lib*.a")
# * strip_path --remove/flatten the (archdir) components of the path
# * strip_dash --coalesce consecutive "-" characters
#
mung_lib_name()
{
    local strip_lib='s|/lib|/|;s|\.a$||;s|\.lib$||;s|\.s||'
    local strip_path="s/$archdir/-/;s|/|-|g"
    local strip_dash='s/--*/-/g;s/^-//;s/-$//g'
    echo $* |
	sed -e "$strip_lib" -e "$strip_path" -e "$strip_dash"
}

#
# expand_ar() --Extract all of a library's objects in a uniform way.
#
expand_ar()
{
    local prefix=$(mung_lib_name $1) file= saved_pwd="$PWD"

    log_cmd mkdir -p "$tmpdir/$prefix"
    log_cmd ln -s "$PWD/$1" "$tmpdir/$prefix/lib.a"
    cd "$tmpdir/$prefix";
    debug 'building library in "%s"' "$PWD"
    log_cmd $ar -x lib.a	# REVISIT: handle .lib too

    for file in *.$o; do		# REVISIT: handle .obj too
	if [ -e "$file" ]; then
	    mv "$file" "../${prefix}-$file"
	else
	    warning 'cannot archive file: "%s"' "$file"
	fi
    done
    cd "$saved_pwd"
    rm -rf "$tmpdir/$prefix"
}

main "$@"
