#
# PERL.MK --Rules for building PERL objects and programs.
#
# Contents:
# perl-build:          --Make scripts "executable".
# perl-src-var-defined: --Test if "enough" of the perl SRC vars. are defined.
# perl-clean:          --Remove script executables.
# perl-tidy:           --perl-specific customisations for the "tidy" target.
# perl-toc:            --Build the table-of-contents for PERL-ish files.
# perl-src:            --perl-specific customisations for the "src" target.
# todo:                --Report unfinished work (identified by keyword comments)
#
perllibdir      = $(exec_prefix)/lib/perl5/$(subdir)
PERL_SRC=$(PL_SRC) $(PM_SRC) $(T_SRC)
PERL_TRG = $(PL_SRC:%.pl=%)

#
# %.pm:		--Rules for installing perl libraries
#
%:			%.pl;	$(INSTALL_PROGRAM) $? $@
$(perllibdir)/%.pm:	%.pm;	$(INSTALL_FILE) $? $@

#
# perl-build: --Make scripts "executable".
#
pre-build:	perl-src-var-defined
build:	$(PERL_TRG)

#
# perl-src-var-defined: --Test if "enough" of the perl SRC vars. are defined.
#
perl-src-var-defined:
	@if [ -z '$(PL_SRC)$(PM_SRC)$(T_SRC)' ]; then \
	    printf $(VAR_UNDEF) "PL_SRC, PM_SRC or T_SRC"
	    echo 'run "make src" to define them'; \
	    false; \
	fi >&2
#
# xgettext support
#
X_PL_FLAGS = -k__ '-k$$__' -k%__ -k__x -k__n:1,2 -k__nx:1,2 -k__xn:1,2 -kN__ -k

#
# perl-clean: --Remove script executables.
#
.PHONY: perl-clean
clean:	perl-clean
distclean:	perl-clean
perl-clean:
	$(RM) $(PERL_TRG)

#
# perl-tidy: --perl-specific customisations for the "tidy" target.
#
.PHONY:	perl-tidy
tidy:	perl-tidy
perl-tidy:
	$(ECHO_TARGET)
	perltidy --profile=$(DEVKIT_HOME)/etc/.perltidyrc $(PERL_SRC)

#
# perl-toc: --Build the table-of-contents for PERL-ish files.
#
.PHONY: perl-toc
toc:	perl-toc
perl-toc:
	$(ECHO_TARGET)
	mk-toc $(PERL_SRC)

#
# perl-src: --perl-specific customisations for the "src" target.
#
.PHONY:	perl-src
src:	perl-src
perl-src:
	$(ECHO_TARGET)
	@mk-filelist -qn PL_SRC *.pl
	@mk-filelist -qn PM_SRC *.pm
	@mk-filelist -qn T_SRC *.t

#
# todo: --Report unfinished work (identified by keyword comments)
#
.PHONY: perl-todo
todo:	perl-todo
perl-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(PERL_SRC) /dev/null || true

#
# *.pot --extract strings for internationalisation.
#
$(PACKAGE).pot:	$(ALL_SRC)
	xgettext $(XFLAGS) $(X_PL_FLAGS) $(PERL_SRC) -o $@
