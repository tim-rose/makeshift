#
# TAP.MK --Rules for running unit tests with the TAP framework.
#
# Contents:
# test:    --Run all the tests, and summarise them.
# test[%]: --Run a particular test.
#
# Remarks:
# TAP tests may be run individually, but are usually executed via the
# *prove* command, which aggregates and summarises the overall test
# run.
#
# To add a test to the suite run by *prove*, add it as a dependant
# of the `test-tap` target.
#
PROVE ?= prove
ALL_PROVE_FLAGS = $(TARGET.PROVE_FLAGS) $(LOCAL.PROVE_FLAGS) \
    $(PROJECT.PROVE_FLAGS) $(ARCH.PROVE_FLAGS) $(OS.PROVE_FLAGS) \
    $(PROVE_FLAGS)

%.tap:	%;	./$* > $@
%.tap:	%.t;	perl $*.t > $@

#
# test: --Run all the tests, and summarise them.
#
test:	test-tap
test-tap: | cmd-exists[$(PROVE)]
	$(ECHO_TARGET)
	$(PROVE) $(ALL_PROVE_FLAGS) $^

#
# test[%]: --Run a particular test.
#
test[%]:	$(archdir)/%;      $(archdir)/$*
test[%.sh]:	%;      ./$*
