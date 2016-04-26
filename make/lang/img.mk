#
# IMG.MK --Rules for installing and building image files
#
# Contents:
# install-img: --Install various image files to wwwdir.
# src-img:     --Update PNG_SRC, GIF_SRC, JPG_SRC macros.
#
.PHONY: $(recursive-targets:%=%-img)

IMG_SRC = $(PNG_SRC) $(GIF_SRC) $(JPG_SRC) $(SVG_SRC)

$(wwwdir)/%.png:	%.png;	$(INSTALL_FILE) $? $@
$(wwwdir)/%.gif:	%.gif;	$(INSTALL_FILE) $? $@
$(wwwdir)/%.jpeg:	%.jpeg;	$(INSTALL_FILE) $? $@
$(wwwdir)/%.jpg:	%.jpg;	$(INSTALL_FILE) $? $@
$(wwwdir)/%.svg:	%.svg;	$(INSTALL_FILE) $? $@

$(datadir)/%.png:	%.png;	$(INSTALL_FILE) $? $@
$(datadir)/%.gif:	%.gif;	$(INSTALL_FILE) $? $@
$(datadir)/%.jpeg:	%.jpeg;	$(INSTALL_FILE) $? $@
$(datadir)/%.jpg:	%.jpg;	$(INSTALL_FILE) $? $@
$(datadir)/%.svg:	%.svg;	$(INSTALL_FILE) $? $@

#
# install-img: --Install various image files to wwwdir.
#
install-img:	install-png install-gif install-jpg install-svg

install-png:	$(PNG_SRC:%=$(wwwdir)/%)
install-gif:	$(GIF_SRC:%=$(wwwdir)/%)
install-jpg:	$(jpg_SRC:%=$(wwwdir)/%)
install-svg:	$(svg_SRC:%=$(wwwdir)/%)

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
