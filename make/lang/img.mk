#
# IMG.MK --Rules for installing and building image files
#
# Contents:
# install-img:   --Install various image files to wwwdir.
# uninstall-img: --Uninstall the default ".img" files.
# src-img:       --Update PNG_SRC, GIF_SRC, JPG_SRC macros.
#
.PHONY: $(recursive-targets:%=%-img)

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
	$(RMDIR) -p $(wwwdir) 2>/dev/null || true

#
# src-img: --Update PNG_SRC, GIF_SRC, JPG_SRC macros.
#
src:	src-img
src-img:
	$(ECHO_TARGET)
	@mk-filelist -qn PNG_SRC *.png
	@mk-filelist -qn GIF_SRC *.gif
	@mk-filelist -qn JPG_SRC *.jpeg *.jpg
	@mk-filelist -qn SVG_SRC *.svg
