#
# GOOGLETEST.MK --Rules for building and running tests with googletest.
#
# Remarks:
# The googletest rules assume that you're developing C++ code, and
# make reference to make variables defined in the lang/c++ module.
#
GTEST_LIBS = gtest_main gtest dl util

build: $(archdir)/googletest

$(archdir)/googletest:	$(TEST_OBJ)
	$(ECHO_TARGET)
	@echo $(C++) -o $@ $(C++_ALL_FLAGS) $(C++_LDFLAGS) \
	    $^ $(C++_LDLIBS) $(TEST_LIBS:%=-l%)
	@$(C++) -o $@ $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) $(C++_LDFLAGS) \
	    $^ $(C++_LDLIBS) $(GTEST_LIBS:%=-l%)

#
# google-test: --Run googletest with arch defined in the environment.
#
.PHONY:	google-test
test:	google-test
google-test:
	archdir=$(archdir) $(archdir)/googletest

.PHONY:	clean-googletest
clean:	clean-googletest
clean-googletest:
	$(RM) $(archdir)/googletest
