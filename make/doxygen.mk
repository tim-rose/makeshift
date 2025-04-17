#
# DOXYGEN.MK --Make targets for creating code documentation with "doxygen".
#
# Contents:
#
# Remarks:
# The detailed behaviour of doxygen depends on its config file,
# assumed to be "doxygen.con", and in particular it is assumed that
# this config (until I can muster a better solution) dumps its output
# into the "dox" sub-directory.
#
DOX_CONFIG ?= doxygen.conf
DOX_OUTPUT ?= dox

doc-html:	doc-dox
doc-dox:
	$(ECHO_TARGET)
	doxygen $(DOX_CONFIG)

clean:	clean-dox
distclean:	clean-dox

.PHONY: clean-dox
clean-dox:	;	$(RM) -r $(DOX_OUTPUT)
