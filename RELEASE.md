# Makeshift Releases

This document summarises the changes and features for each makeshift release.

## Release 0.4.3

* fixes to install-strip

## Release 0.4.1

* fix: executables can now reliably depend on *subdir*/`$(archdir)/lib.a`
* changed sequence of auto-generated include/link paths.

## Release 0.4.0

* more, consistently named install helper targets (e.g. `install-c++`)
* uninstall targets (e.g. `uninstall-c++`)
* total rebuild of library handling:
  * most configuration is optional (`LIB`, `LIB_ROOT`, etc.)
  * `LIB_OBJ` no longer used
  * *include* automatically cleaned
* much better *ld* handling:
  * `LIB_PATH` sets include and *ld* path
  * specify libraries as `-l<libname>`, get dependency tracking
* markdown ships with some useful default CSS
* more/better assertions in tap
* added `install-strip`, used by RPM targets.
* java builds class files incrementally.

## Release 0.3.0
## Release 0.2.0
## Release 0.1.0
