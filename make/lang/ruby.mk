#
# RUBY.MK --Rules for building RUBY objects and programs.
#
# Contents:
# clean-ruby: --Remove script executables.
# toc-ruby:   --Build the table-of-contents for ruby files.
# src-ruby:   --Create a list of ruby files as the RB_SRC macro.
# todo:       --Report unfinished work (identified by keyword comments)
#
.PHONY: $(recursive-targets:%=%-ruby)

rubylibdir      = $(exec_prefix)/lib/ruby/$(subdir)
RB_TRG = $(RB_SRC:%.rb=%)

$(rubylibdir)/%.rb:	%.rb;	$(INSTALL_FILE) $? $@

pre-build:	src-var-defined[RB_SRC]
build:	$(RB_TRG)

#
# clean-ruby: --Remove script executables.
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
# src-ruby: --Create a list of ruby files as the RB_SRC macro.
#
src:	src-ruby
src-ruby:
	$(ECHO_TARGET)
	@mk-filelist -qn RB_SRC *.rb
#
# todo: --Report unfinished work (identified by keyword comments)
#
todo:	todo-ruby
todo-ruby:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(RB_SRC) /dev/null || true
