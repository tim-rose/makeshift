#
# DOXYGEN.MK --Make targets for creating code documentation with "doxygen".
#
# Contents:
#
# Remarks:
# The detailed behaviour of doxygen depends on its config file,
# assumed to be "doxygen_config", and in particular it is assumed that
# this config (until I can muster a better solution) dumps its output
# into the "doxygen_output" directory.
#
DOX_CONFIG = doxygen_config
DOX_OUTPUT = doxygen_output

doc:	doc-dox
doc-dox:
	$(ECHO_TARGET)
	doxygen $(DOX_CONFIG)

clean:	clean-dox
distclean:	clean-dox
clean-dox:	;	$(RM) -r $(DOX_OUTPUT)
