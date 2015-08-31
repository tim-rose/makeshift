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

AR		= $(windriver)-ar
AS		= $(windriver)-as
#ASFLAGS = --64
CC		= $(windriver)-gcc
CHMOD		= chmod
CP		= cp
CXX		= $(windriver)-g++
GDB		= $(windriver)-gdb
GREP		= grep
INDENT         	= indent
LD		= $(windriver)-ld
MV		= mv
NM		= $(windriver)-nm
OBJCOPY		= $(windriver)-objcopy
OBJDUMP		= $(windriver)-objdump
RANLIB		= $(windriver)-ranlib
STRIP		= $(windriver)-strip
