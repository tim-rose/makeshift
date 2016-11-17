#
# RUBY.MK --Rules for building RUBY objects and programs.
#
# Contents:
# build-ruby:       --Build ruby executables
# install-ruby:     --Install ruby as executables.
# install-ruby-lib: --Install ruby as library modules.
# clean:            --Remove ruby script executables.
# toc-ruby:         --Build the table-of-contents for ruby files.
# src:              --Define RB_SRC.
# todo:             --Report unfinished work in ruby files.
#
.PHONY: $(recursive-targets:%=%-ruby)

rubylibdir      = $(exec_prefix)/lib/ruby/$(subdir)
RB_TRG = $(RB_SRC:%.rb=%)

%:			%.rb;	$(INSTALL_SCRIPT) $*.rb $@
$(rubylibdir)/%.rb:	%.rb;	$(INSTALL_FILE) $? $@

#
# build-ruby: --Build ruby executables
#
# Remarks:
# Ruby doesn't distinguish between executables and libraries, so
# nothing is built by default, but this helper target will.
#
build-ruby:	$(RB_TRG)

#
# install-ruby: --Install ruby as executables.
#
install-ruby: $(RB_SRC:%.rb=$(bindir)/%); $(ECHO_TARGET)
uninstall-ruby:
	$(ECHO_TARGET)
	$(RM) $(RB_SRC:%.rb=$(bindir)/%)
	$(RMDIR) -p $(bindir) 2>/dev/null || true

#
# install-ruby-lib: --Install ruby as library modules.
#
.PHONY: install-ruby-lib uninstall-ruby-lib
install-ruby-lib: $(RB_SRC:%.rb=$(rubylibdir)/%.rb); $(ECHO_TARGET)
uninstall-ruby-lib:
	$(ECHO_TARGET)
	$(RM) $(RB_SRC:%.rb=$(rubylibdir)/%)
	$(RMDIR) -p $(rubylibdir) 2>/dev/null || true


#
# clean: --Remove ruby script executables.
#
clean:	clean-ruby
clean-ruby:
	$(RM) $(RB_TRG)

#
# toc-ruby: --Build the table-of-contents for ruby files.
#
toc:	toc-ruby
toc-ruby:
	$(ECHO_TARGET)
	mk-toc $(RB_SRC)

#
# src: --Define RB_SRC.
#
src:	src-ruby
src-ruby:
	$(ECHO_TARGET)
	@mk-filelist -qn RB_SRC *.rb
#
# todo: --Report unfinished work in ruby files.
#
todo:	todo-ruby
todo-ruby:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(RB_SRC) /dev/null || true
