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

The script you're now running will complete the installation.

I'll ask a few questions, and then try to run the install myself,
with the choices you've made.

If you wish to install devkit system-wide and automatically used by all
users of make, install it to "/usr/local".  Otherwise, install devkit
to your home directory ("$HOME"), and then you can use 
"make -I$HOME/include".

EOF
sleep 2 && echo ""
export OS=$(uname -s)
export ARCH=$(uname -m|sed -e "s/i.86/i386/")
export DEVKIT_HOME=$(
    prompt "where will devkit be installed?" ${DEVKIT_HOME:-$HOME}) || exit
export prefix=$(
    prompt "where will devkit install software?" ${prefix:-/usr/local}) || exit
export VCS=$(
    prompt 'what version-control system are you using?' ${VCS:-'git'}) || exit
if ! make -I $PWD/make installdirs install; then
    echo "whoops.  It looks like that didn't work."
else
    cat <<EOF

OK!  It looks like we're all installed.
To use the devkit system, you'll need to setup some environment
variables.  You should probably put something like this in your ".bashrc":

export OS=\$(uname -s)
export ARCH=\$(uname -m | sed -e "s/i.86/i386/")
export DEVKIT_HOME=$DEVKIT_HOME
export prefix=$prefix
export VCS=$VCS

Now, the make will resume (and fail).
It won't work until you update the environment variables described above.

EOF
fi
exit 1
