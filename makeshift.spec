#
# MAKESHIFT.SPEC --RPM build configuration for makeshift.
#
%define debug_package %{nil}
Summary: Makeshift, a build system using recursive make.
Name: %{name}
Version: %{version}
Release: %{release}
License: MIT, Copyright (c) 2015 Tim Rose
URL: git@github.com:tim-rose/makeshift.git
Group: Development/Libraries
Buildarch: noarch
Packager: Timothy Rose <tim.rose@acm.org>
AutoReqProv: no

%description
Makeshift is a build system implemented as GNU make files.  It provides
default implementations of the "standard" high-level targets used for
common software and documentation tasks, as described in the GNU make
manual (i.e. "build", "clean", "distclean", "install" etc.).
