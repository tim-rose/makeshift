#
# GOOGLETEST.MK --Rules for building and running tests with googletest.
#
# Remarks:
# The googletest rules assume that you're developing C++ code, and
# make reference to make variables defined in the lang/c++ module.
#
GTEST_LIBS = gtest_main gtest dl util
TEST_XML = test-results.xml
TEST_EXE = $(archdir)/googletest

build: $(archdir)/googletest

$(TEST_EXE):	$(TEST_OBJ)
	$(ECHO_TARGET)
	@echo $(C++) -o $@ $(C++_ALL_FLAGS) $(C++_LDFLAGS) \
	    $^ $(C++_LDLIBS) $(TEST_LIBS:%=-l%)
	@$(C++) -o $@ $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) $(C++_LDFLAGS) \
	    $^ $(C++_LDLIBS) $(GTEST_LIBS:%=-l%)

#
# google-test: --Run googletest with arch defined in the environment.
#
.PHONY:	test-google
test:	test-google
test-google:
	archdir=$(archdir) $(TEST_EXE) --gtest_output=xml:$(TEST_XML)

.PHONY:	googletest-clean
clean:	googletest-clean
googletest-clean:
	$(RM) $(TEST_EXE) $(TEST_XML)
