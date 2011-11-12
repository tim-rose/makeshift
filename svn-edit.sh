#!/bin/sh 
# 
# SVN-EDIT --Edit a sub-version commit message, using a template. 
# 
# 
if [ $# != 1 ]; then
    echo "usage: $0 file" 
    exit 1 
fi
file=$1 
 
editor=$VISUAL 
[ -z $editor ] && editor=$EDITOR 
[ -z $editor ] && editor=vi
 
if [ -f $HOME/etc/template.svn ]; then
    cp $HOME/etc/template.svn $file.$$
else
    cat <<EOT >$file.$$ 
This change closes/refs #9999.
EOT
fi
cat $file >> $file.$$ 
 
sum=$(cksum $file.$$)
if $editor $file.$$; then 
    newsum=$(cksum $file.$$) 
    if [ "$newsum" != "$sum" ]; then 
	rm -f $file 
	mv $file.$$ $file 
    else			# no changes 
	rm -f $file.$$ 
    fi 
else 
    echo "editor \"$editor\" failed" 
    exit 1 
fi
exit 0
