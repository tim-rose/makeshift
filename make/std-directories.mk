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
archdir         = $(OS)-$(ARCH)
rootdir 	= $(DESTDIR)/$(prefix)
rootdir_opt 	= $(DESTDIR)/$(prefix)/$(opt)
#exec_prefix = $(rootdir)/$(archdir)	# (GNU std)
exec_prefix	= $(rootdir_opt)/$(usr)

bindir		= $(exec_prefix)/bin
sbindir 	= $(exec_prefix)/sbin
#libexecdir	= $(exec_prefix)/libexec/$(archdir)/$(subdir)	# (GNU std)
libexecdir	= $(exec_prefix)/libexec/$(subdir)
datadir		= $(exec_prefix)/share/$(subdir)

sysconfdir	= $(rootdir)/etc/$(opt)/$(subdir)
initdir		= $(DESTDIR)/etc/init.d
divertdir	= $(rootdir)/var/lib/divert/$(subdir)
sharedstatedir	= $(rootdir_opt)/com/$(subdir)
localstatedir	= $(rootdir)/var/$(opt)/$(subdir)
srvdir 		= $(rootdir)/srv/$(subdir)
wwwdir 		= $(rootdir)/srv/www/$(subdir)

#libdir		= $(exec_prefix)/lib/$(archdir)	# (GNU std)
libdir		= $(exec_prefix)/lib/$(subdir)
libbasedir	= $(exec_prefix)/lib
infodir		= $(rootdir_opt)/info
lispdir		= $(rootdir_opt)/share/emacs/site-lisp

includedir	= $(rootdir_opt)/$(usr)/include/$(subdir)
mandir		= $(datadir)/man
man1dir		= $(mandir)/man1
man2dir		= $(mandir)/man2
man3dir		= $(mandir)/man3
man4dir		= $(mandir)/man4
man5dir		= $(mandir)/man5
man6dir		= $(mandir)/man6
man7dir		= $(mandir)/man7
man8dir		= $(mandir)/man8
