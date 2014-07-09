#!/bin/sh
#
# MK-FILELIST --update the file list in a makefile
#
# Remarks:
# This script updates a makefile SRC definitions.  It relies on
# finding the tag (specified by -n) as the text string:
#     <tag> = file ...
#
# It copes OK with continuations etc. (I think!)  Note that the
# makefile is updated in-place, and the original makefile is saved as
# makefile.bak.
#
#
PATH=$PATH:/usr/libexec:/usr/local/libexec
tmp=${TMPDIR:-/tmp}/$$
backup=.bak
directories=
file=Makefile
name=FILES
wrap=60
usage="Usage: mk-filelist file..."

log_message() {	printf "mk-filelist: ";	printf "$@"; printf "\n"; } >&2
notice()      { log_message "$@"; }
info()        { if [ "$verbose" -o "$debug" ]; then log_message "$@"; fi; }
debug()       { if [ "$debug" ]; then log_message "$@"; fi; }

#
# list_files() --List the files named on the command line, possibly filtered
#
list_files()
{
    if [ "$phony" ]; then
	echo $*
    else
	ls $ls_opts $*
    fi
}

while getopts "b:df:n:pw:vq_" c
do
    case $c in
    b)  backup="$OPTARG";;
    d)  directories=1;;
    f)  file="$OPTARG";;
    n)  name="$OPTARG";;
    p)  phony=1;;
    w)  wrap="$OPTARG";;
    v)  verbose=1 debug=;;
    q)  verbose=  debug=;;
    _)  verbose=1 debug=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

if [ $# -eq 0 ]; then
    info '%s: no files' "$name"
    exit 0
fi

if [ ! -f "$file" ]; then
    notice '%s: no such file' "$file"
    exit 1
fi

if [ "$directories" ]; then
    ls_opts=-d
fi

#
# construct the new name-list, into $tmp-def.mk
#
list_files $* 2>/dev/null |	# echo, but one per line
    sed -e 's/^\.\///g' -e 's/ \.\// /g' | # trim any "./"
    fmt -w $wrap |			   # wrap as a paragraph, then mung...
    sed -e "1,1s/^/${name} = /" \
          -e '2,$s/^/    /' \
          -e '1,$s/$/ \\/' \
          -e '$s/ \\//' >$tmp-def.mk	# ...into a makefile-ish spec.

if [ "$backup" ]; then
    cp $file $file$backup
fi

#
# Split makefile into the stuff before and (including+after) the matching tag.
# Strip off the existing NAME= stuff in the .post file by deleting up to
# the first line that isn't a continuation.
#
sed  -e "/^${name}[ 	]*=/,\$d" <$file >$tmp-pre.mk
sed  -n -e "/^${name}/,\$p" <$file > $tmp-def+post.mk

if [ -s $tmp-def+post.mk ]; then
    if head -1 <$tmp-def+post.mk | grep -s '\\$' >/dev/null; then
        debug "%s: updating paragraph definition" $name
        sed -e '1,/[^\\]$/d' <$tmp-def+post.mk >$tmp-post.mk
    else
        debug "%s: updating one line definition" $name
        sed -e '1d' <$tmp-def+post.mk >$tmp-post.mk
    fi
    cat $tmp-pre.mk $tmp-def.mk $tmp-post.mk > $file
else
    info "%s: new definition" $name
    cp $file $tmp-spare.mk
    cat $tmp-def.mk $tmp-spare.mk  > $file # add to start of file
    rm $tmp-spare.mk
fi
rm -f $tmp-pre.mk $tmp-def.mk $tmp-post.mk $tmp-def+post.mk
exit 0
