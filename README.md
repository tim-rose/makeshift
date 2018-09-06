# Devkit --Recursive Make Considered Useful

*Devkit* is a library of **make** rules and helper **shell** scripts
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
 * can build in parallel!

## Installation
Just want to get started? try this:

```bash
$ sh install.sh
```

It installs **devkit** into _/usr/local/_; that's where GNU **make**
will look for these files by default.

Any arguments you pass to the install script are passed through to
**make**, so if you would like to install **devkit** in a custom location:

```bash
$ sh install.sh prefix=/my/location
```

Within the prefix root (e.g. _/usr/local_), **devkit** will install into
the following sub-directories:

 * $prefix/_bin_ --helper **shell** scripts
 * $prefix/_etc_ --development tool configuration files
 * $prefix/_include_ --**make** rules and targets
 * $prefix/_lib/sh_ --**shell** library code

### Uninstallation

*Devkit* supports the (GNU make documented) `uninstall` target.  To
remove devkit from your system:

```bash
$ make uninstall
```

This target will remove all installed files, and any directories made empty.

## Usage

To use **devkit**, add the following to your _Makefile_:

```makefile
include devkit.mk
```

This will include **devkit**'s targets and pattern rules for doing common
actions recursively.  In particular, the targets described/suggested
in the GNU make manual are implemented.  Here's a brief list of some
of them:

* build --build all the things!
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

**Devkit** supports several languages, some more completely than
others.  The languages I use a lot have better, more complete support,
the others, less so.  Sorry, I only have so many fingers.  To include
the rules for developing in a particular language, declare them in the
makefile.  You can declare more than one language.  For example, in a
directory containing C, Python and some config files, start with
something like:

```makefile
language = c python conf

include devkit.mk
```

The language rules define *how* to build, but not *what* to build.
**Make** needs a list of source files to build, and **devkit** has
targets for building the lists, and updating the makefile. After
running the following command:

```bash
$ make src
```

The makefile will self-update to something like:

```makefile
CONF_SRC = mung.conf
PY_SRC = mung.py
C_SRC = main.c calc.c fileops.c
C_MAIN_SRC = main.c

language = c python conf

include devkit.mk
```

**Make** needs one more thing to build correctly; the `main` depends
on, and must be linked with, `calc` and `fileops`.  **Devkit** defines
some macros that make that easy:

```makefile
CONF_SRC = mung.conf
PY_SRC = mung.py
C_SRC = main.c calc.c fileops.c
C_MAIN_SRC = main.c

language = c python conf

include devkit.mk

$(C_MAIN): $(C_OBJ)
```

### Help and Debugging

**Devkit** has a number of targets and features to help you (er, me)
to see what's going on.

 * `make +help` --prints some help text based on the files you have included
 * `make +vars` --prints all of the defined variables, and their values
 * `make +var[`_name_`]` --prints a single variable value
 * `make +stddirs` --prints the list of "standard" build and install directories
 * `make VERBOSE=1` --prints the targets and their dependants when executing.

## Contributing

I'd appreciate help adding and improving the language support,
particularly for languages that I don't use yet.  You know the drill:

 1. create a feature branch: `git checkout -b my-idea`
 1. commit your changes: `git commit -am 'My new idea'`
 1. push to the branch: `git push origin my-idea`
 1. submit a pull request.

## Licence

You are licensed to use devkit under the MIT licence.
See the file `LICENCE` for details.
