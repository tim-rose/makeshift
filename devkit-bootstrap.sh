#!/bin/sh
#
# DEVKIT-BOOTSTRAP --Perform initial setup of the devkit system.
#

#
# prompt() --Prompt for a value, with a default.
#
# Parameters:
# $1	--the prompt
# $2	--the default value
#
# Returns:
# Success: true, and echoes the new value; Failure: false
#
prompt()
{
    local read_opts=
    if [ "$BASH" ]; then
	read_opts=-e		# bash supports readline
    fi
    if [ "$2" ]; then
	prompt_text="$1 [$2]: "
    else
	prompt_text="$1: "
    fi
    if read $read_opts -p "$prompt_text" value; then
	if [ "$value" ]; then
	    echo $value
	else
	    echo $2			# default
	fi
	return 0
    fi
    return 1
}

#
# main...
#
cat <<EOF

Hello, it looks like this is the first time you've tried to install devkit!
Unfortunately, devkit needs to be installed before it can install itself.
Fortunately, I'm here to help.
I'll ask a few questions, and then try to run the install myself,
with the choices you've made.

Basically, if you want to install devkit for system-wide use, you should
install it into "/usr/local", otherwise install into your home directory.
EOF
sleep 2 && echo ""
export DEVKIT_HOME=$(prompt "where will devkit be installed?" $HOME) || exit
export DESTDIR=$(prompt "where devkit install software?" $DEVKIT_HOME) || exit
export VCS=$(prompt 'version-control system?' 'git') || exit
if ! make -I $PWD/make installdirs install; then
    echo "whoops.  It looks like that didn't work."
else
    cat <<EOF

OK!  It looks like we're all installed.
To use the devkit system, you'll need to setup some environment
variables.  You should probably put something like this in your ".bashrc":

export DEVKIT_HOME=$DEVKIT_HOME
export DESTDIR=$DESTDIR
export VCS=$VCS
export OS=\$(uname -s)
export ARCH=\$(uname -m)

Now, the make will resume (and fail).
It won't work until you update the environment variables described above.

EOF
fi
exit 1
