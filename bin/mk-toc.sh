#!/bin/sh
#
# MK-TOC.SH --Update a file's Table-Of-Contents comment block.
#
# Contents:
# toc_split() --Split a file into pieces for TOC manipulation.
# set_type()  --Adjust for a particular file type.
#
usage="Usage: mk-toc [options] file..."

log_message() { printf "mk-toc: "; printf "$@"; printf "\n"; } >&2
notice()      { log_message "$@"; }
info()        { if [ "$verbose" ]; then log_message "$@"; fi; }
debug()       { if [ "$debug" ]; then log_message "$@"; fi; }
log_quit()    { notice "$@"; exit 1 ; }

#
# toc_split() --Split a file into pieces for TOC manipulation.
#
# Remarks:
# This function runs an awk script to split the input file into
# three pieces:
#  * $file.pre	--content prior to the TOC block
#  * $file.toc	--the content of the TOC block proper
#  * $file.post	--post-TOC content.
#
toc_split()
{
    comment_prefix_rgx=$(echo "$comment_prefix" | sed -e 's/\*/[*]/')
    debug 'comment_prefix="%s", comment_prefix_rgx="%s"' \
	"$comment_prefix" "$comment_prefix_rgx"
    debug 'toc_label="%s"' "$toc_label"
    awk "
function info(str) {
    if (\"$verbose\") {
        printf(\"%s\n\", str);
    }
}
function debug(str) {
    if (\"$debug\") {
        printf(\"line %d: %s\n\", NR, str);
    }
}

BEGIN {
    mode = 0;
    entry = 0;
    output = \"$1.pre\";
    debug(\"pre...\");
}

# Match the start of the TOC block
/^$comment_prefix_rgx *$toc_label:/ {
    debug(\"toc...\");
    mode = 1;
    output = \"/dev/null\";
    next;
}

# Match a TOC-entry in the body text
/^$comment_prefix_rgx *$name_rgx  *--/ {
    if (mode == 1) {
        next
    }
    if (mode > 1) {
        line=\$0;
        sub(/^$comment_prefix_rgx */, \"\", line);
        n = match(line, /  *--/)
        if (n > 0) {
            name[entry] = substr(line, 1, n-1);
            summary[entry] = substr(line, RSTART+RLENGTH)
            entry += 1;
        }
    }
}

# Print each line to the current (mode-specific) output file
{
    if (mode == 1) {
        debug(\"post...\");
        mode = 2;
        output = \"$1.post\";
    }
    print \$0 > output;
}

# Summarise the TOC entries found in the entire file
END {
    max = 0;
    for (i=0; i<entry; ++i) {
        if (length(name[i]) > max) {
            max = length(name[i]);
        }
    }
    if (max > 20) {
        max = 20;
    }
    info(sprintf(\"%s: %d entries\", \"$1\", entry));
    output = \"$1.toc\";
    printf(\"%s%s:\n\", \"$comment_prefix\", \"$toc_label\") > output;
    for (i=0; i<entry; ++i) {
        printf(\"%s%-\" max \"s --%s\\n\", \"$comment_prefix\",
            name[i], summary[i]) > output;
    }
}

" $1
} >&2

#
# set_type() --Adjust for a particular file type.
#
set_type()
{
    local suffix=$(echo $1| sed -e 's/.*\([.][^.][^.]*\)$/\1/')
    info 'setting style for "%s"' $suffix
    case $suffix in
	.c|.h|.css)
	    comment_prefix=' * '
	    ;;
	.c++|.cpp|.C|.js)
	    comment_prefix='// '
	    ;;
	Makefile|.mk|.conf|.cfg|.ini|.p[lm]|.sh*|.awk|.sed|.rb)
	    comment_prefix='# '
	    ;;
	.sql|.ada|.htm|.html)
	    comment_prefix='-- '
	    ;;
	.el|.lisp)
	    comment_prefix='; '
	    ;;
	.man|.[0-9])
	    comment_prefix='.\" '
	    ;;
	*)
	    log_quit 'unknown file type "%s"' $suffix
	    ;;
    esac
}

#
# main...
#
toc_label='Contents'
comment_prefix=''

#
# name_rgx defines the sort of thing we're trying to match as a
# table-of-contents entry.  For most languages, this will be a
# language identifier, but for makefiles we want to allow the extended
# characters that targets can have (e.g. '%'), as well as common
# filesystem characters (e.g. ".", "/") too. Furthermore, the trailing
# punctuation should support some meaningful variations used to
# indicate type/scope in some languages.  Some illustrative examples:
#
#  * function()  --describe a function
#  * variable[]  --describe an array
#  * variable{}  --describe a hash/struct
#  * $variable:  --describe a variable, in some languages
#  * @variable:  --describe an instance variable or an array, in some languages
#  * %variable:  --describe a perl hash?
#  * install:    --describe a make target
#  * objdir/%.o: --describe a make pattern rule
#  * etc.
#
# Still confused? Oh well, sorry 'bout that.
#
name_rgx='[a-zA-Z0-9_.$%@*\/][-a-zA-Z0-9_.$%@*\/]*[][{}():%*][][{}():%*]*'

#
# process command-line options
#
while getopts "bl:n:p:t:vq_" c
do
    case $c in
    b)  backup="bak";;
    l)  toc_label=$OPTARG;;
    n)  name_rgx=$OPTARG;;
    p)  comment_prefix=$OPTARG;;
    t)  type=$OPTARG;;
    v)  verbose=1; debug=;;
    q)  verbose=; debug=;;
    _)  verbose=1; debug=1;;
    \?)	echo $usage >&2
	exit 2;;
    esac
done
shift $(($OPTIND - 1))

if [ "$type" ]; then
    set_type $type
fi

for file; do
    if [ ! "$type" ]; then
	set_type $file
    fi
    info 'file: %s' $file

    if toc_split $file; then
	if [ "$backup" ]; then
	    cp $file $file.$backup
	fi
	if [ -f "$file.post" ]; then
	    cat $file.pre $file.toc $file.post > $file
	else
	    info '%s: no toc' $file
	fi
	if [ !"$debug" ]; then
	    rm -f $file.pre $file.toc $file.post
	fi
    fi
done
