#
# IMG.MK --Rules for installing and building image files
#
# Contents:
# install-img:   --Install various image files to wwwdir.
# uninstall-img: --Uninstall the default ".img" files.
# src-img:       --Update PNG_SRC, GIF_SRC, JPG_SRC macros.
#
.PHONY: $(recursive-targets:%=%-img)

ifdef autosrc
    LOCAL_PNG_SRC := $(wildcard *.png)
    LOCAL_GIF_SRC := $(wildcard *.gif)
    LOCAL_JPG_SRC := $(wildcard *.jpg)
    LOCAL_SVG_SRC := $(wildcard *.svg)

    PNG_SRC ?= $(LOCAL_PNG_SRC)
    GIF_SRC ?= $(LOCAL_GIF_SRC)
    JPG_SRC ?= $(LOCAL_JPG_SRC)
    SVG_SRC ?= $(LOCAL_SVG_SRC)
endif

IMG_SRC = $(PNG_SRC) $(GIF_SRC) $(JPG_SRC) $(SVG_SRC)

#
# Installation pattern rules...
#
$(wwwdir)/%.png:	%.png;	$(INSTALL_DATA) $? $@
$(wwwdir)/%.gif:	%.gif;	$(INSTALL_DATA) $? $@
$(wwwdir)/%.jpeg:	%.jpeg;	$(INSTALL_DATA) $? $@
$(wwwdir)/%.jpg:	%.jpg;	$(INSTALL_DATA) $? $@
$(wwwdir)/%.svg:	%.svg;	$(INSTALL_DATA) $? $@

$(datadir)/%.png:	%.png;	$(INSTALL_DATA) $? $@
$(datadir)/%.gif:	%.gif;	$(INSTALL_DATA) $? $@
$(datadir)/%.jpeg:	%.jpeg;	$(INSTALL_DATA) $? $@
$(datadir)/%.jpg:	%.jpg;	$(INSTALL_DATA) $? $@
$(datadir)/%.svg:	%.svg;	$(INSTALL_DATA) $? $@

#
# Conversion pattern rules.
#
# Remarks:
# Images are typically "binary" files, which are not handled
# well by most VCSs.  These pattern rules define a path for
# building the binary file from SVG, which is (UTF8) text.
#
%.png:	%.svg;		$(CONVERT) $*.svg $@
%.jpg:	%.svg;		$(CONVERT) $*.svg $@
%.gif:	%.svg;		$(CONVERT) $*.svg $@

#
# install-img: --Install various image files to wwwdir.
#
install-img:	install-png install-gif install-jpg install-svg

install-png:	$(PNG_SRC:%=$(wwwdir)/%)
install-gif:	$(GIF_SRC:%=$(wwwdir)/%)
install-jpg:	$(JPG_SRC:%=$(wwwdir)/%)
install-svg:	$(SVG_SRC:%=$(wwwdir)/%)

#
# uninstall-img: --Uninstall the default ".img" files.
#
uninstall-img:
	$(ECHO_TARGET)
	$(RM) $(PNG_SRC:%=$(wwwdir)/%) $(GIF_SRC:%=$(wwwdir)/%) $(JPG_SRC:%=$(wwwdir)/%) $(SVG_SRC:%=$(wwwdir)/%)
	$(RMDIR) -p $(wwwdir) 2>/dev/null ||:

#
# src-img: --Update PNG_SRC, GIF_SRC, JPG_SRC macros.
#
src:	src-img
src-img:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn PNG_SRC *.png
	@mk-filelist -f $(MAKEFILE) -qn GIF_SRC *.gif
	@mk-filelist -f $(MAKEFILE) -qn JPG_SRC *.jpg
	@mk-filelist -f $(MAKEFILE) -qn SVG_SRC *.svg
