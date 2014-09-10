#!/bin/sh
#
# INSTALL.SH --Simple install script for devkit.
#
# Usage:
#     sh install.sh [make arg.s...]
#
# E.g.
#     sh install.sh prefix=$HOME/local
#
# Remarks:
# We kick things off with a self-hosted install of the make system,
# which has the side effect of creating some auto-generated files.
# Then we can do a full self-hosted install.
#
mk_args="OS=linux ARCH=all $*"

install_self() ( cd make && make build -I$PWD $mk_args )
install_all() { make -I$PWD/make build install $mk_args; }

os_warning()
{
    cat <<EOF

Usage:
To use devkit, you will need to define two variables: OS, ARCH.
These variables customise the behaviour of make in system-specific ways.
You can either define them as environment variables or per-invocation of
make, e.g.:

    export OS=linux
    export ARCH=x86_64
    make
or
    make OS=linux ARCH=x86_64

It looks like your system might be:
    OS=$(uname -s|tr A-Z a-z|sed -e 's/-.*//')
    ARCH=$(uname -m)
EOF
}

prefix_warning()
{
    if [ "$prefix" != '/usr/local' ]; then
    cat <<EOF

You have installed devkit into "$prefix".
To use the devkit you just installed you will need to invoke make as:

    make -I$prefix
EOF
    fi
    cat <<EOF

Some of the tool-related targets will reference configuration
files in "$prefix/etc".  For these targets to work, you will need to
define the DEVKIT_HOME variable, e.g.:

    export DEVKIT_HOME=$prefix
EOF
}

if install_self && install_all; then
    eval $(make -I$PWD/make +var[prefix] $mk_args)
    cat <<EOF

Devkit has been successfully installed.
$(os_warning)
$(prefix_warning)
EOF
else
    echo "install failed!"
    false
fi
