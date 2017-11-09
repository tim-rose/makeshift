#
# PERL.MK --Rules for building PERL objects and programs.
#
# Contents:
# %.pm:    --Rules for installing perl programs and libraries.
# build:   --Make perl scripts "executable".
# install: --install perl binaries and libraries.
# clean:   --Remove perl script executables.
# tidy:    --perl-specific customisations for the "tidy" target.
# toc:     --Build the table-of-contents for perl files.
# src:     --Define PL_SRC, PM_SRC, T_SRC.
# todo:    --Report unfinished work (identified by keyword comments)
#
.PHONY: $(recursive-targets:%=%-perl)

ifdef autosrc
    LOCAL_PL_SRC := $(wildcard *.pl)
    LOCAL_PM_SRC := $(wildcard *.pm)
    LOCAL_T_SRC := $(wildcard *.t)

    PL_SRC ?= $(LOCAL_PL_SRC)
    PM_SRC ?= $(LOCAL_PM_SRC)
    T_SRC ?= $(LOCAL_T_SRC)
endif

perllibdir      = $(exec_prefix)/lib/perl5/$(subdir)
PERL_SRC=$(PL_SRC) $(PM_SRC) $(T_SRC)
PERL_TRG = $(PL_SRC:%.pl=%)

%:			%.pl;	$(INSTALL_SCRIPT) $? $@
$(bindir)/%:		%.pl;	$(INSTALL_SCRIPT) $? $@
$(perllibdir)/%.pm:	%.pm;	$(INSTALL_DATA) $? $@
$(perllibdir)/%.pm:	$(archdir)/%.pm;	$(INSTALL_DATA) $? $@

#
# %.pm: --Rules for installing perl programs and libraries.
#
%:			%.pl;	$(INSTALL_SCRIPT) $*.pl $@
$(perllibdir)/%.pm:	%.pm;	$(INSTALL_DATA) $? $@

#
# build: --Make perl scripts "executable".
#
build:	build-perl
build-perl:	$(PERL_TRG)

#
# install: --install perl binaries and libraries.
#
install-perl:	$(PL_SRC:%.pl=$(bindir)/%) $(PM_SRC:%.pm=$(perllibdir)/%.pm)
	$(ECHO_TARGET)

uninstall-perl:	$(PL_SRC:%.pl=$(bindir)/%) $(PM_SRC:%.pm=$(perllibdir)/%.pm)
	$(ECHO_TARGET)
	$(RM) $(PL_SRC:%.pl=$(bindir)/%) $(PM_SRC:%.pm=$(perllibdir)/%.pm)
	$(RMDIR) -p $(bindir) $(perllibdir) 2>/dev/null || true

#
# xgettext support
#
X_PL_FLAGS = -k__ '-k$$__' -k%__ -k__x -k__n:1,2 -k__nx:1,2 -k__xn:1,2 -kN__ -k

#
# clean: --Remove perl script executables.
#
clean:	clean-perl
distclean:	clean-perl
clean-perl:
	$(RM) $(PERL_TRG)

#
# tidy: --perl-specific customisations for the "tidy" target.
#
tidy:	tidy-perl
tidy-perl:
	$(ECHO_TARGET)
	perltidy --profile=$(DEVKIT_HOME)/etc/.perltidyrc $(PERL_SRC)

#
# toc: --Build the table-of-contents for perl files.
#
toc:	toc-perl
toc-perl:
	$(ECHO_TARGET)
	mk-toc $(PERL_SRC)

#
# src: --Define PL_SRC, PM_SRC, T_SRC.
#
src:	src-perl
src-perl:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn PL_SRC *.pl
	@mk-filelist -f $(MAKEFILE) -qn PM_SRC *.pm
	@mk-filelist -f $(MAKEFILE) -qn T_SRC *.t

#
# todo: --Report unfinished work (identified by keyword comments)
#
todo:	todo-perl
todo-perl:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(PERL_SRC) /dev/null || true

#
# *.pot --extract strings for internationalisation.
#
$(PACKAGE).pot:	$(ALL_SRC)
	xgettext $(XFLAGS) $(X_PL_FLAGS) $(PERL_SRC) -o $@
