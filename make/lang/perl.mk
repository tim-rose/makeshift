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
PERL_SRC=$(PL_SRC) $(PM_SRC) $(T_SRC)
PERL_TRG = $(PL_SRC:%.pl=%)

#
# %.pl:		--Rules for installing perl scripts
#
%:			%.pl;	@$(INSTALL_SCRIPT) $(PERL_PATH) $? $@
$(bindir)/%:		%.pl;	@$(INSTALL_SCRIPT) $(PERL_PATH) $? $@
$(libexecdir)/%:	%.pl;	@$(INSTALL_SCRIPT) $(PERL_PATH) $? $@
$(sysconfdir)/%:	%.pl;	@$(INSTALL_SCRIPT) $(PERL_PATH) $? $@
$(perllibdir)/%.pm:	%.pm;	$(INSTALL_DATA) $? $@

#
# perl-build: --Make scripts "executable".
#
pre-build:	perl-src-var-defined
build:	$(PERL_TRG)

#
# perl-src-var-defined: --Test if "enough" of the perl SRC vars. are defined.
#
perl-src-var-defined:
	@test -n "$(PL_SRC)" -o -n "$(PM_SRC)" -o -n "$(T_SRC)" || \
	    { $(VAR_UNDEFINED) "PL_SRC, PM_SRC or T_SRC"; }

#
# xgettext support
#
X_PL_FLAGS = -k__ '-k$$__' -k%__ -k__x -k__n:1,2 -k__nx:1,2 -k__xn:1,2 -kN__ -k

#
# perl-clean: --Remove script executables.
#
.PHONY: perl-clean
clean:	perl-clean
perl-clean:
	$(RM) $(PERL_TRG)

#
# perl-tidy: --perl-specific customisations for the "tidy" target.
#
tidy:	perl-tidy
.PHONY:	perl-tidy
perl-tidy:
	@$(ECHO) "++ make[$@]@$$PWD"
	perltidy --profile=$(DEVKIT_HOME)/etc/.perltidyrc $(PERL_SRC)

#
# perl-toc: --Build the table-of-contents for PERL-ish files.
#
.PHONY: perl-toc
toc:	perl-toc
perl-toc:
	@$(ECHO) "++ make[$@]@$$PWD"
	mk-toc $(PERL_SRC)

#
# perl-src: --perl-specific customisations for the "src" target.
#
src:	perl-src
.PHONY:	perl-src
perl-src:	
	@$(ECHO) "++ make[$@]@$$PWD"
	@mk-filelist -qn PL_SRC *.pl
	@mk-filelist -qn PM_SRC *.pm
	@mk-filelist -qn T_SRC *.t

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: perl-todo
todo:	perl-todo
perl-todo:
	@$(ECHO) "++ make[$@]@$$PWD"
	@$(GREP) -e TODO -e FIXME -e REVISIT $(PERL_SRC) /dev/null || true

#
# ???
#
$(PACKAGE).pot:	$(ALL_SRC)
	xgettext $(XFLAGS) $(X_PL_FLAGS) $(PERL_SRC) -o $@
