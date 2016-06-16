# Devkit --Recursive Make Considered Useful

This project is a library of **make** rules and helper **shell** scripts
for building software recursively.  Recursive **make** has got a lot of bad
press over the years, and some of it's justified.  I'll leave that
debate for the philosophers; I find that managing any large build
system is challenging no matter which way you slice it.  The approach
taken by **devkit** is to apply recursive make in a fairly disciplined
way, and this seems to work as good as any other.

## Installation
Just want to get started? try this:
```bash
sh install.sh
```
It installs **devkit** into _/usr/local/_; that's where GNU **make**
will look for these files by default.

Any arguments you pass to the install script are passed through to
**make**, so if you would like to install **devkit** in a custom location:

```bash
sh install.sh prefix=/my/location
```

Within the prefix root (e.g. _/usr/local_), **devkit** will install into
the following sub-directories:

 * _bin_ --helper **shell** scripts
 * _etc_ --development tool configuration files
 * _include_ --**make** rules and targets
 * _lib/sh_ --**shell** library code

## Usage

To use **devkit**, add the following to your _Makefile_:

```makefile
include devkit.mk
```

This will include **devkit**'s targets and pattern rules for doing common
actions recursively.

### Help and Debugging

**Devkit** has a number of targets and features to help you (er, me)
to see what's going on.

 * `make +help`
 * `make +vars`
 * `make +var[`_name_`]`
 * `make ECHO=echo`

### Languages

## Contributing

 1. fork it!
 1. create a feature branch: `git checkout -b my-idea`
 1. commit your changes: `git commit -am 'My new idea'`
 1. push to the branch: `git push origin my-idea`
 1. submit a pull request.

## Licence
