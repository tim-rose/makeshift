#
# UNITY.MK --Rules for running unit tests with the Unity framework.
#
# Contents:
# test:    --Run all the tests.
# test[%]: --Run a particular test.
#

#
# test: --Run all the tests.
#
$(TEST_MAIN): -lunity
test:	test-unity
test-unity: [$(TEST_MAIN:%=test[%])]
	$(ECHO_TARGET)

#
# test[%]: --Run a particular test.
#
test[%]:	$(archdir)/%;      $(archdir)/$*
