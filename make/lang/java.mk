#
# JAVA.MK --Rules for building Java objects and programs.
#
# Contents:
# %.class: --Compile a java file into an arch-specific sub-directory.
# build:   --Build all the java sources that have changed.
# install: --install java binaries and libraries.
# clean:   --Remove java class files.
# src:     --Update the JAVA_SRC macro.
# tags:    --Build vi, emacs tags files.
# todo:    --Report "unfinished work" comments in Java files.
#
# Remarks:
# The "lang/java" module provides support for the Java programming
# language.  It requires the JAVA_SRC variable to be defined.  Because
# javac has high startup cost, it is usually not practical to build
# Java files one-by-one, even in parallel.  So, the "src" target
# assumes that the Makefile is at the root of a tree of Java source
# code, and sets JAVA_SRC to be all the source in all sub-directories.
#
.PHONY: $(recursive-targets:%=%-java)

ifdef autosrc
    LOCAL_JAVA_SRC := $(shell find . -type f -name '*.java')

    JAVA_SRC ?= $(LOCAL_JAVA_SRC)
endif

JAVAC	?= javac
ALL_JAVA_FLAGS = $(OS.JAVA_FLAGS) $(ARCH.JAVA_FLAGS) $(LOCAL.JAVA_FLAGS) \
    $(TARGET.JAVA_FLAGS) $(JAVA_FLAGS)

JAVA_OBJ	= $(JAVA_SRC:%.java=$(archdir)/%.class)

javalibdir      = $(exec_prefix)/lib/java/$(subdir)

$(javalibdir)/%.class:	$(archdir)/%.class;	$(INSTALL_DATA) $? $@

#
# %.class: --Compile a java file into an arch-specific sub-directory.
#
# Remarks:
# ".class" files are arch-neutral aren't they?
#
$(archdir)/%.class: %.java | $(archdir)
	$(ECHO_TARGET)
	$(JAVAC) $(ALL_JAVA_FLAGS) -d $(archdir) $*.java

#
# build: --Build all the java sources that have changed.
#
# Remarks:
# Because the JVM is slow to startup, it is usually inefficient
# to compile the sources one-by-one, even in parallel.  To work
# around this, the (phony) build target depends on a (non-phony)
# log file, which in turn depends on the java sources.  The log
# target builds the files that are more recent than the log file.
#
build:		build-java
build-java: $(archdir)/build-java.log

$(archdir)/build-java.log: $(JAVA_SRC) | $(archdir)
	$(ECHO_TARGET)
	$(JAVAC) $(ALL_JAVA_FLAGS) -d $(archdir) $?
	date '+%Y-%m-%d %H:%M:%S: $?' > $@

#
# install: --install java binaries and libraries.
#
install-java:	$(PL_SRC:%.pl=$(bindir)/%) $(PM_SRC:%.pm=$(javalibdir)/%.pm)
	$(ECHO_TARGET)

uninstall-java:	$(PL_SRC:%.pl=$(bindir)/%) $(PM_SRC:%.pm=$(javalibdir)/%.pm)
	$(ECHO_TARGET)
	$(RM) $(PL_SRC:%.pl=$(bindir)/%) $(PM_SRC:%.pm=$(javalibdir)/%.pm)
	$(RMDIR) -p $(bindir) $(javalibdir) 2>/dev/null || true

#
# clean: --Remove java class files.
#
# Remarks:
# This target removes the ".class" files that can be easily derived
# from the ".java" file list, but it misses inner classes that don't
# map to a ".java" file.  In the end it doesn't matter that much;
# these files will get rebuilt as a side effect anyway, and distclean
# deletes the entire directory containing all class files.
#
distclean:	clean-java
clean:	clean-java
clean-java:
	$(ECHO_TARGET)
	$(RM) $(archdir)/build-java.log
	echo $(JAVA_OBJ:.class=*.class) | xargs $(RM)

#
# src: --Update the JAVA_SRC macro.
#
src:	src-java
src-java:
	$(ECHO_TARGET)
	@mk-filelist -qn JAVA_SRC $$(find . -type f -name '*.java')
#
# tags: --Build vi, emacs tags files.
#
tags:	tags-java
tags-java:	src-var-defined[JAVA_SRC]
	$(ECHO_TARGET)
	ctags $(JAVA_SRC) && \
	etags $(JAVA_SRC); true

#
# todo: --Report "unfinished work" comments in Java files.
#
todo:	todo-java
todo-java:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(JAVA_SRC) /dev/null || true
