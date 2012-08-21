#
# RUBY.MK --Rules for building RUBY objects and programs.
#
# Contents:
# ruby-clean: --Remove script executables.
# ruby-toc:   --Build the table-of-contents for RUBY-ish files.
# ruby-src:   --ruby-specific customisations for the "src" target.
# todo:         --Report unfinished work (identified by keyword comments)
#
# %.rb:		--Rules for installing ruby scripts
#
RB_TRG = $(RB_SRC:%.rb=%)

%:			%.rb;	@$(INSTALL_SCRIPT) $(RUBY_PATH) $? $@
$(bindir)/%:		%.rb;	@$(INSTALL_SCRIPT) $(RUBY_PATH) $? $@
$(libexecdir)/%:	%.rb;	@$(INSTALL_SCRIPT) $(RUBY_PATH) $? $@

pre-build:	src-var-defined[RB_SRC]
build:	$(RB_TRG)

#
# ruby-clean: --Remove script executables.
#
.PHONY: ruby-clean
clean:	ruby-clean
ruby-clean:
	$(RM) $(RB_TRG)

#
# ruby-toc: --Build the table-of-contents for RUBY-ish files.
#
.PHONY: ruby-toc
toc:	ruby-toc
ruby-toc:
	@$(ECHO) "++ make[$@]@$$PWD"
	mk-toc $(RB_SRC)

#
# ruby-src: --ruby-specific customisations for the "src" target.
#
.PHONY:	ruby-src
src:	ruby-src
ruby-src:	
	$(ECHO) "++ make[$@]@$$PWD"
	@mk-filelist -qn RB_SRC *.rb
#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: ruby-todo
todo:	ruby-todo
ruby-todo:
	@$(ECHO) "++ make[$@]@$$PWD"
	@$(GREP) -e TODO -e FIXME -e REVISIT $(RB_SRC) /dev/null || true
