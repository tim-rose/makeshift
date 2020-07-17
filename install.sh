#!/bin/sh
#
# INSTALL.SH --Simple install script for makeshift.
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
mk_args="OS=unknown ARCH=all $*"
PATH=$PWD/bin:$PATH

build_bin() { make -I$PWD/make -C bin build $mk_args; }
build_self() { make -I$PWD/make build $mk_args; }
install_all() { make -I$PWD/make install $mk_args; }

os_warning()
{
    cat <<EOF

Usage:
To use makeshift, you will need to define two variables: OS, ARCH.
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

You have installed makeshift into "$prefix".
To use the makeshift you just installed you will need to invoke make as:

    make -I$prefix
EOF
    fi
    cat <<EOF

Some of the tool-related targets will reference configuration
files in "$prefix/etc".  For these targets to work, you will need to
define the MAKESHIFT_HOME variable, e.g.:

    export MAKESHIFT_HOME=$prefix
EOF
}

if build_bin && build_self && install_all; then
    eval $(make -I$PWD/make +var[prefix] $mk_args)
    cat <<EOF

Makeshift has been successfully installed.
$(os_warning)
$(prefix_warning)
EOF
else
    echo "install failed!"
    false
fi
