#
# GOOGLETEST.MK --Rules for building and running tests with googletest.
#
# Remarks:
# The googletest rules assume that you're developing C++ code, and
# make reference to make variables defined in the lang/c++ module.
#
GTEST_LIBS = gtest_main gtest dl util
TEST_XML = google-tests.xml
TEST_EXE = $(archdir)/googletest

build: $(TEST_EXE)

$(TEST_EXE):	$(TEST_OBJ)
	$(ECHO_TARGET)
	@echo $(C++) -o $@ $(C++_ALL_FLAGS) $(ALL_LDFLAGS) \
	    $^ $(ALL_LDLIBS) $(GTEST_LIBS:%=-l%)
	@$(C++) -o $@ $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) $(ALL_LDFLAGS) \
	    $^ $(ALL_LDLIBS) $(GTEST_LIBS:%=-l%)

#
# google-test: --Run googletest with arch defined in the environment.
#
test:	test-google
.PHONY:	test-google
test-google:	$(TEST_EXE)
	archdir=$(archdir) $(TEST_EXE) --gtest_output=xml:$(TEST_XML)

clean:	googletest-clean
distclean:	googletest-clean

.PHONY:	googletest-clean
googletest-clean:
	$(RM) $(TEST_EXE) $(TEST_XML)
