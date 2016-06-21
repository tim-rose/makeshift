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
export system_root	= $(DESTDIR)
export system_confdir	= $(system_root)/etc/$(subdir)
export pkgver		= $(PACKAGE)$(VERSION:%=-%)

export archdir		= $(HW:%=%-)$(OS:%=%-)$(ARCH)
export rootdir	 	= $(DESTDIR)/$(prefix)
export rootdir_opt 	= $(DESTDIR)/$(prefix)/$(opt)
#export exec_prefix = $(rootdir)/$(archdir)	# (GNU std)
export exec_prefix	= $(rootdir_opt)/$(usr)

export bindir		= $(exec_prefix)/bin
export sbindir 	= $(exec_prefix)/sbin
#export libexecdir	= $(exec_prefix)/libexec/$(archdir)/$(subdir)	# (GNU std)
export libexecdir	= $(exec_prefix)/libexec/$(subdir)
export datadir		= $(exec_prefix)/share/$(subdir)

export sysconfdir	= $(rootdir)/etc/$(opt)/$(subdir)

export divertdir	= $(rootdir)/var/lib/divert/$(subdir)
export sharedstatedir	= $(rootdir_opt)/com/$(subdir)
export localstatedir	= $(rootdir)/var/$(opt)/$(subdir)
export srvdir 		= $(rootdir)/srv/$(subdir)
export wwwdir 		= $(rootdir)/srv/www/$(subdir)

#export libdir		= $(exec_prefix)/lib/$(archdir)	# (GNU std)
export libdir		= $(exec_prefix)/lib/$(subdir)
export libbasedir	= $(exec_prefix)/lib
export infodir		= $(rootdir_opt)/info
export lispdir		= $(rootdir_opt)/share/emacs/site-lisp

export includedir	= $(rootdir_opt)/$(usr)/include/$(subdir)
export docdir		= $(exec_prefix)/share/doc/$(pkgver)/$(subdir)
export mandir		= $(datadir)/man
export man1dir		= $(mandir)/man1
export man2dir		= $(mandir)/man2
export man3dir		= $(mandir)/man3
export man4dir		= $(mandir)/man4
export man5dir		= $(mandir)/man5
export man6dir		= $(mandir)/man6
export man7dir		= $(mandir)/man7
export man8dir		= $(mandir)/man8
