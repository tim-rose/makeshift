#
# TAP.MK --Rules for running unit tests.
#
TAP_TRG	= $(TAP_TESTS:%=%.tap)
%.tap:	%;	$* > $@
%.tap:	%.t;	perl $*.t > $@

pre-test:	var-defined[TAP_TESTS] 
test:	test-tap
.PHONY:	test-tap
test-tap:	$(TAP_TRG);	prove --exec cat $(TAP_TRG)

clean:		clean-tap
distclean:	clean-tap

.PHONY:		clean-tap
clean-tap:
	$(RM) $(TAP_TRG)
