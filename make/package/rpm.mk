#
# RPM.MK --Rules for building RPM packages.
#
# Contents:
#
# Remarks:
# TBD.
#

#
# $(PACKAGE)-files.txt: --Build the list of files that RPM will "package".
#
# Remarks:
# This forces a "trial" install just so it can gather the
# list of files that the spec file needs to know about.
#
BUILD_ROOT	= .root
RM_PREFIX       =

#
# %-files.txt: --Build the RPM's file section contents as a file.
#
# Remarks:
# This is defined as a pattern rule, so it can be overridden by
# and explicit rule if needed.
#
%-files.txt:	$(BUILD_ROOT)
	find $(BUILD_ROOT) -not -type d | \
            sed -e 's|^$(BUILD_ROOT)||' | mk-rpm-files >$@

$(BUILD_ROOT):
	$(MAKE) install DESTDIR=$(BUILD_ROOT) prefix= usr=usr

clean:	clean-rpm

.PHONY:	clean-rpm
clean-rpm:
	$(RM) -r $(BUILD_ROOT) $(PACKAGE)-files.txt
