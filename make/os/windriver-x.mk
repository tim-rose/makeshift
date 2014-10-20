#
# windriver-x.MK	--Macros and definitions for Wind River Cross compiles.
#
# Remarks:
# This is a cross-compile setup to compile Wind River stuff on an otherwise
# standard Linux (Ubuntu?) box.
#
SYSROOT = /opt/windriver/wrlinux/5.0-intel-xeon-core/sysroots/intel_xeon_core-wrs-linux
windriver = x86-64-wrswrap-linux-gnu


OS.C_CPPFLAGS = -I/usr/local/include -sysroot $(SYSROOT) -Wl,--hash-style=gnu
OS.C++_CPPFLAGS = -I/usr/local/include -sysroot $(SYSROOT) -Wl,--hash-style=gnu
OS.LDFLAGS = -m elf_x86_64 --sysroot $(SYSROOT)

CC = $(windriver)-gcc
CXX = $(windriver)-g++
AS = $(windriver)-as
#ASFLAGS = --64
LD = $(windriver)-ld
GDB = $(windriver)-gdb
STRIP = $(windriver)-strip
RANLIB = $(windriver)-ranlib
OBJCOPY = $(windriver)-objcopy
OBJDUMP = $(windriver)-objdump
AR = $(windriver)-ar
NM = $(windriver)-nm

INDENT          = gnuindent
