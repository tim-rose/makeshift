#
# std-directories.mk --Definitions of the common/standard directories.
#
# Remarks:
# These directories are set according to a blend of the following variables:
#
#  * DESTDIR	-- an alternative root (e.g. chroot jail, pkg-building root)
#  * prefix	-- the application's idea of its root installation directory
#  * opt	-- FSHS "opt" component (undefined if not FSHS)
#  * usr	-- bindir modfier: either undefined or "usr"
#  * archdir	-- system+architecture-specific bindir modifier (unused)
#
# In typical usage, DESTDIR should be undefined (it's explicitly set
# as needed by some of the packaging targets), and prefix should be
# set to either "/usr/local" or $HOME (or a subdirectory).  Note that
# GNU make will search for include files in /usr/local/include, so
# installing devkit itself into /usr/local is a win.  However if you
# install devkit into $HOME, you must use/alias make as
# "make -I$HOME/include".
#
system_root	= $(DESTDIR)

#
# Remarks:
# system_confdir is a bit of a hack, for folks that want to install
# into "/etc" as well as the adjusted $sysconfdir.
#
system_confdir	= $(system_root)/etc/$(subdir)
export pkgver		= $(PACKAGE)$(VERSION:%=-%)

export archdir	= $(VARIANT:%=%-)$(OS:%=%-)$(ARCH)
export gendir	= $(archdir)/gen
rootdir	 	= $(DESTDIR)/$(prefix)
rootdir_opt 	= $(DESTDIR)/$(prefix)/$(opt)
#exec_prefix = $(rootdir)/$(archdir)	# (GNU std)
exec_prefix	= $(rootdir_opt)/$(usr)

bindir		= $(exec_prefix)/bin
sbindir 	= $(exec_prefix)/sbin
#libexecdir	= $(exec_prefix)/libexec/$(pkgver)/$(archdir)/$(subdir)	# (GNU std)
libexecdir	= $(exec_prefix)/libexec/$(subdir)
datarootdir     = $(exec_prefix)/share/$(subdir)
#datadir	= $(exec_prefix)/share/$(pkgver)/$(subdir)	# (GNU std)
datadir		= $(datarootdir)

sysconfdir	= $(rootdir)/etc/$(opt)/$(subdir)

divertdir	= $(rootdir)/var/lib/divert/$(subdir)
sharedstatedir	= $(rootdir_opt)/com/$(subdir)
localstatedir	= $(rootdir)/var/$(opt)/$(subdir)
srvdir 		= $(rootdir)/srv/$(subdir)
wwwdir 		= $(rootdir)/srv/www/$(subdir)
localedir 	= $(exec_prefix)/share/locale

includedir	= $(rootdir_opt)/$(usr)/include/$(subdir)
librootdir	= $(exec_prefix)/lib
libdir		= $(librootdir)/$(subdir)
lispdir		= $(rootdir_opt)/share/emacs/site-lisp

infodir		= $(rootdir_opt)/info
docdir		= $(exec_prefix)/share/doc/$(pkgver)/$(subdir)
htmldir		= $(docdir)
dvidir		= $(docdir)
psdir		= $(docdir)
pdfdir		= $(docdir)

mandir		= $(datadir)/man
man1dir		= $(mandir)/man1
man2dir		= $(mandir)/man2
man3dir		= $(mandir)/man3
man4dir		= $(mandir)/man4
man5dir		= $(mandir)/man5
man6dir		= $(mandir)/man6
man7dir		= $(mandir)/man7
man8dir		= $(mandir)/man8
