#
# COVERAGE.MK --Rules for building coverage reports with gcov, lcov.
#
# Remarks:
# The coverage module provides the phony targets "coverage" "html-coverage".
# These targets build textual and html coverage reports respectively.
#
# The including makefile must define these macros:
# GCOV_FILES	  --the ".gcov" files (e.g. $(C_SRC:%.c=%.c.gcov)
# GCOV_GCDA_FILES --the ".gcda" files (e.g. $(C_SRC:%.cpp=$(archdir)/%.gcda))
#
# Coverage is tied fairly closely to gcov/lcov, and therefore the GCC
# toolchain.  The "coverage" target is auto-recursive, and is used to
# generate the text reports in the current directory.  The HTML reports
# act on an entire tree, so they are not generated recursively; you must
# move to the directory and "make html-coverage".
#
.PHONY: coverage html-coverage
coverage:	$(GCOV_FILES)
html-coverage:	$(archdir)/coverage/index.html

#
# the ".gcda" files won't exist if the code hasn't been run, so we
# have a dummy target that silently returns true.
#
$(archdir)/%.gcda:	;	@:

#
# %.c.gcov: --Build text-format reports as requested.
#
# Remarks:
# The gcov tool outputs some progress information, most of which is
# (transparently) discarded.
#
%.c.gcov:	$(archdir)/%.gcda
	@echo gcov -o $(archdir) $*.c
	@gcov -o $(archdir) $*.c | sed -ne '/^Lines/s/.*:/gcov $*.c: /p'

%.cpp.gcov:	$(archdir)/%.gcda
	@echo gcov -o $(archdir) $*.cpp
	@gcov -o $(archdir) $*.cpp | sed -ne '/^Lines/s/.*:/gcov $*.cpp: /p'

#
# coverage.trace: --Collate the coverage data for this tree of files.
#
$(archdir)/coverage.trace:	$(GCOV_GCDA_FILES)
	lcov --capture $(LCOV_EXCLUDE) --directory . >$@
	lcov --remove $@ '/usr/include/*' >$$$$.tmp && mv $$$$.tmp $@

#
# coverage/index.html: --Create the html-formatted coverage reports.
#
$(archdir)/coverage/index.html:	$(archdir)/coverage.trace
	genhtml --demangle-cpp --output-directory $(archdir)/coverage \
	    $(archdir)/coverage.trace

#
# clean: --Remove the coverage data and reports
#
.PHONY:	clean-coverage
clean:	clean-coverage
clean-coverage:
	$(RM) -r $(GCOV_FILES) $(archdir)/coverage.trace $(archdir)/coverage
