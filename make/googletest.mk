#
# GOOGLETEST.MK --Rules for building and running tests with googletest.
#
# Remarks:
# The googletest rules assume that you're developing C++ code, and
# make reference to make variables defined in the lang/c++ module.
#
build: $(archdir)/gtest

$(archdir)/gtest:	$(TEST_OBJ)
	$(ECHO_TARGET)
	@echo $(C++) -o $@ $(C++_ALL_FLAGS) $(C++_LDFLAGS) \
		    $(TEST_OBJ) $(C++_LDLIBS) -lgtest_main -lgtest -ldl -lutil
	@$(C++) -o $@ $(C++_WARN_FLAGS) $(C++_ALL_FLAGS) $(C++_LDFLAGS) \
		    $(TEST_OBJ) $(C++_LDLIBS) -lgtest_main -lgtest -ldl -lutil

test:	google-test

google-test:
	archdir=$(archdir) $(archdir)/gtest

clean:	clean-gtest

clean-gtest:
	$(RM) $(archdir)/gtest
