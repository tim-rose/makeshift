# Makeshift --Recursive Make Considered Useful

**Makeshift** is a library of **make** rules and helper **shell** scripts
for building software recursively. It:

 * implements almost all of the "standard" make targets documented
   in the GNU make manual,
 * implements several additional targets for handling
   SDLC tasks (e.g. static analysis, code coverage, etc.)
 * supports the common compiled and script languages (e.g. C, C++,
   Python, Perl, Ruby, shell, awk, sed, etc), including both static
   and shared libraries
 * supports compile-step frameworks (e.g. lex, yacc, xsd, protobuf,
   Qt, etc.)
 * supports several test frameworks (googletest, pytest, tap, phptest)
 * can package the project as a RPM or DEB installable package.
 * can build reliably in parallel!

## Installation
Just want to get started? try this:

```shell
$ sh install.sh
```

It installs **makeshift** into _/usr/local/_; that's where GNU **make**
will look for these files by default.

Any arguments you pass to the install script are passed through to a
**make** invocation to do the work, so if you would like to install
**makeshift** in a custom location:

```shell
$ sh install.sh prefix=/my/location
```

Within the prefix root (e.g. _/usr/local_), **makeshift** will install into
the following sub-directories:

 * $prefix/_bin_ --helper **shell** scripts
 * $prefix/_etc_ --development tool configuration files
 * $prefix/_include_ --**make** rules and targets
 * $prefix/_lib/sh_ --**shell** library code

### Uninstallation

**Makeshift** supports the (GNU **make** documented) `uninstall` target.  To
remove makeshift from your system:

```shell
$ make uninstall
```

This target will remove all installed files, and any directories made
empty thereby.

## Usage

To use **makeshift**, add the following to your _Makefile_:

```makefile
include makeshift.mk
```

This will include **makeshift**'s targets and pattern rules for doing common
actions recursively.  In particular, the targets described/suggested
in the GNU make manual are implemented.  Here's a brief list of some
of them:

* all, build --build all the things!
* test --run tests
* install, uninstall --install/remove artefacts to a standard location
* clean, distclean --various cleanup tasks
* dist --construct a versioned **tar** file of the current directory
* doc --build documentation.

Note that the bare basic behaviour for these targets is to do nothing,
but recurse.  Things get more interesting when you include various language
definitions; each language defines extra "do something" targets that are
attached to (made dependants of) the standard targets.

### Languages

**Makeshift** supports several languages, some more completely than
others.  The languages I use a lot have better, more complete support,
the others, less so.  Sorry, I only have so many fingers.  To include
the rules for developing in a particular language, declare them in the
*makefile*.  You can declare more than one language.  For example, in a
directory containing C, Python and some configuration files, start with
something like:

```makefile
language = c python conf

include makeshift.mk
```

The language rules define *how* to build, but not *what* to build.
**Make** needs a list of source files to build, and **makeshift** has
targets for building the lists, and updating the makefile. After
running the following command:

```shell
$ make src
```

The makefile will self-update to something like:

```makefile
CONF_SRC = mung.conf
PY_SRC = mung.py
C_SRC = main.c calc.c fileops.c
C_MAIN_SRC = main.c

language = c python conf

include makeshift.mk
```

**Make** needs one more thing to build correctly; the `main` depends
on, and must be linked with, `calc` and `fileops`.  **Makeshift** defines
some macros that make that easy:

```makefile
CONF_SRC = mung.conf
PY_SRC = mung.py
C_SRC = main.c calc.c fileops.c
C_MAIN_SRC = main.c

language = c python conf

include makeshift.mk

$(C_MAIN): $(C_OBJ)
```

To install (and uninstall) the built targets add these lines to the
*Makefile*:

```makefile
install: install-all
uninstall: uninstall-all
```

### Help and Debugging

**Makeshift** has a number of targets and features to help you (er, me)
to see what's going on.

 * `make +help` --prints some help text based on the makefiles you have included
 * `make +vars` --prints all of the defined variables, and their values (disabled on Windows)
 * `make +var[`_name_`]` --prints a single variable value
 * `make +stddirs` --prints the list of "standard" build and install directories
 * `make +version` --prints the current **makeshift** version
 * `make +features` --prints the current **make** features
 * `make +dirs` --prints the include directories used by **make**
 * `make +files` --prints the additional files included by **make**
 * `make VERBOSE=1` --prints the targets and their dependants when executing.
 * `make VERBOSE=color` --prints the targets+dependants with ANSI coloring.

## Contributing

I'd appreciate help adding and improving the language support,
particularly for languages that I don't use yet.  You know the drill:

 1. create a feature branch: `git checkout -b my-idea`
 1. commit your changes: `git commit -am 'My new idea'`
 1. push to the branch: `git push origin my-idea`
 1. submit a pull request.

## License

You are licensed to use makeshift under the MIT license.
See the file `LICENSE` for details.

## TODO

* create MSI packages using Wix
* create automated tests
* add support for "performance testing" targets
* better support for embedded projects and cross-compilation
* automatically install-on-demand **makeshift** commands (and a project's libraries?).
