# Makeshift Operating System Customisations

## Windows

### C/C++

If you're using the VisualStudio toolchain (i.e. cl.exe), you'll
probably have to add some environment variables, because the tools and
their supporting DLLs are not in the path by default.

Note that you'll need to add the following to your path:

* *visual-studio*/VC/bin
* *visual-studio*/VC/Common7/IDE

### POSIX Environment

#### Git (MinGW)

Git for Windows includes an installation of (at least some of) the
POSIX environment as implemented by MinGW.  Maybe it's a MSYS install?
It's OK, but it's slow and incomplete: there's no compiler, and no
`make`.

#### Cygwin

The Cygwin system tries to layer a POSIX environment over the top of
Windows.  It also has lots of additional packages that can be
installed, some of which are useful for devlopment (e.g. linters, etc.)

#### Windows Subsytem for Linux (WSL)

This project looks like a deliberate act of sabotage on Microsoft's
part.  Then again, most of their design efforts fit that
characterisation, so don't blame to malice what can be easily
achieved by stupidity.

The main problem is that WSL feels like (and as of recently, runs
like) a separate VM hosted on the Windows host.  That means that
Windows and WSL each have a separate filesystem, and
unfortunately it's dangerous to mix/share the two.  In particular:

* WSL cannot `chmod` files on the Windows filesystem
* Windows programs can utterly corrupt files on the WSL filesystem.

Utterly corrupt.  Has a nice ring to it, don't you think?
