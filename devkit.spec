#
# DEVKIT.SPEC --RPM build configuration for devkit.
#
Summary: Devkit, a build system using recursive make.
Name: devkit
Version: 0.2
Release: 3
License: MIT, Copyright (c) 2015 Tim Rose
URL: git@github.com:tim-rose/devkit.git
Group: Development/Libraries
Buildarch: noarch
BuildRoot: %{_tmppath}/%{name}-root
Packager: Timothy Rose <tim.rose@acm.org>
AutoReqProv: no

%description
Devkit is a build system implemented as GNU make files.  It provides
default implementations of the "standard" high-level targets used for
common software and documentation tasks, as described in the GNU make
manual (i.e. "build", "clean", "distclean", "install" etc.).

# Perform the build in the current directory
%define _sourcedir %{expand:%(pwd)}
%define _builddir %{_sourcedir}
%define _rpmdir %{_sourcedir}

%install
%{__rm} -rf $RPM_BUILD_ROOT
%{__make} install DESTDIR=$RPM_BUILD_ROOT prefix=/usr/local

%clean
%{__rm} -rf $RPM_BUILD_ROOT

%files -f devkit-files.txt

%changelog
* Tue Sep 1 2015 Timothy Rose <tim.rose@acm.org>
- Release 1-1:
- Initial release
