#
# PERL.MK --Rules for building PERL objects and programs.
#
# Contents:
# perl-src-defined: --Test if "enough" of the perl SRC vars. are defined.
# %.pm:             --Rules for installing perl programs and libraries.
# build:            --Make perl scripts "executable".
# install:          --install perl binaries and libraries.
# clean:            --Remove perl script executables.
# tidy:             --perl-specific customisations for the "tidy" target.
# toc:              --Build the table-of-contents for perl files.
# src:              --Define PL_SRC, PM_SRC, T_SRC.
# todo:             --Report unfinished work (identified by keyword comments)
#
.PHONY: $(recursive-targets:%=%-perl)

perllibdir      = $(exec_prefix)/lib/perl5/$(subdir)
PERL_SRC=$(PL_SRC) $(PM_SRC) $(T_SRC)
PERL_TRG = $(PL_SRC:%.pl=%)

%:			%.pl;	$(INSTALL_PROGRAM) $? $@
$(bindir)/%:		%.pl;	$(INSTALL_PROGRAM) $? $@
$(perllibdir)/%.pm:	%.pm;	$(INSTALL_FILE) $? $@
$(perllibdir)/%.pm:	$(archdir)/%.pm;	$(INSTALL_FILE) $? $@

#
# perl-src-defined: --Test if "enough" of the perl SRC vars. are defined.
#
perl-src-defined:
	@if [ -z '$(PL_SRC)$(PM_SRC)$(T_SRC)' ]; then \
	    printf $(VAR_UNDEF) "PL_SRC, PM_SRC or T_SRC" \
	    echo 'run "make src" to define them'; \
	    false; \
	fi >&2

#
# %.pm: --Rules for installing perl programs and libraries.
#
%:			%.pl;	$(INSTALL_PROGRAM) $*.pl $@
$(perllibdir)/%.pm:	%.pm;	$(INSTALL_FILE) $? $@

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
	@mk-filelist -qn PL_SRC *.pl
	@mk-filelist -qn PM_SRC *.pm
	@mk-filelist -qn T_SRC *.t

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
