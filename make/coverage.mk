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
#
# the ".gcda" files won't exist if the code hasn't been run, so we
# have a dummy target that silently returns true.
#
$(archdir)/%.gcda:	;	@:

.PHONY: coverage html-coverage
coverage:	$(GCOV_FILES)
html-coverage:	$(archdir)/coverage/index.html

%.c.gcov:	$(archdir)/%.gcda
	gcov -o $(archdir) $*.c

$(archdir)/coverage.info:	$(GCOV_GCDA_FILES)
	lcov --capture --output-file $@ --directory .

$(archdir)/coverage/index.html:	$(archdir)/coverage.info
	genhtml --output-directory $(archdir)/coverage $(archdir)/coverage.info

#
# clean: --Remove the coverage data and reports
#
clean:	clean-coverage
distclean:	clean-coverage
.PHONY:	clean-coverage
clean-coverage:
	$(RM) -r $(GCOV_FILES) $(archdir)/coverage.info $(archdir)/coverage
