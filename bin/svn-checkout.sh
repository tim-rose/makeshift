#!/bin/sh
#
# SVN-CHECKOUT.SH --Checkout a particular version of a SVN package.
#
PATH=$PATH:/usr/libexec:/usr/local/libexec
. log.shl

svn=$SVN_ROOT
url=
rev=tags/latest
while getopts 'b:s:t:qv_' c; do
    case $c in
    s) svn=$OPTARG;;
    t) rev=tags/$OPTARG;;
    b) rev=branches/$OPTARG;;
    q) LOG_LEVEL=notice;;
    v) LOG_LEVEL=info;;
    _) LOG_LEVEL=debug;;
    \?) echo "Usage: svn-checkout [-s svn-root] [-t tag]  packages..." >&2; exit 2;;
    esac
done
shift $(expr $OPTIND - 1)

if [ ! "$svn" ]; then
    echo "SVN_ROOT is not defined!" >&2
    exit 1
fi

for pkg in $*; do
    if ! svn info $svn/$pkg >/dev/null 2>&1; then
	err "not a valid package: %s" $pkg
	continue
    fi

    case $rev in
    */latest)
	rev=$(svn ls $svn/$pkg/tags | 
	    grep [0-9.]* | 
	    sort -n -t. -k 1,1 -k 2,2 -k 3,3 |
	    tail -1 |
	    sed -e "s|/$pkg||" -e 's|/$||')
	if [ "$rev" ]; then
	    rev="tags/$rev"
	fi
	;;
    */trunk) rev=trunk;;
    *)
	rev=$rev
    esac
    if ! svn info $svn/$pkg/$rev >/dev/null 2>&1; then
	err "not a valid release: %s@%s" $pkg $rev
	continue
    else
	info '%s/%s@%s' $svn $pkg $rev
    fi

    if [ -d $pkg ]; then 
	incumbent=$(svn info $pkg | sed -ne "/URL: /s|URL: .*$pkg/||p")
	if [ "$incumbent" != "$rev" ]; then 
	    notice 'removing %s@%s' $pkg $incumbent
	    rm -rf $pkg
	fi; 
    fi
    if [ ! -d $pkg ]; then
	info 'checkout %s@%s' $pkg $rev
	svn co $SVN_ROOT/$pkg/$rev $pkg;
    fi
done
