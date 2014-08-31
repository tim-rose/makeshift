# Devkit --Recursive Make Considered Useful

This project is a library of **make** rules and ancillary **shell** scripts
for building software recursively.  Recursive **make** has got a lot of bad
press over the years, and some of it's justified.  I'll leave that
debate for the philosophers; I find that managing any large build
system is challenging no matter which way you slice it.  The approach
taken by **devkit** is to apply recursive make in a fairly disciplined
way, and this seems to work as good as any other.

## Install
Just want to get started? try this:
```bash
sh install.sh
```
It will install **devkit** into _/usr/local/_, which is where **make**
will look for these files by default.

Any arguments you pass to the install script are passed through to
**make**, so if you would like to install **devkit** in a custom location:

```bash
sh install.sh prefix=/my/location
```

Within the prefix root (e.g. _/usr/local_), **devkit** will install into
the following sub-directories:

 * _bin_ --ancillary **shell** scripts
 * _etc_ --development tool configuration files
 * _include_ --**make** rules and targets
 * _lib/sh_ --**shell** library code
