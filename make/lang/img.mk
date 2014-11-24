#
# IMG.MK --Rules for installing and building image files
#
# Contents:
# img-src: --Update PNG_SRC, GIF_SRC, JPG_SRC macros.
#
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
# img-src: --Update PNG_SRC, GIF_SRC, JPG_SRC macros.
#
src:	img-src
.PHONY:	img-src
img-src:
	$(ECHO_TARGET)
	@mk-filelist -qn PNG_SRC *.png
	@mk-filelist -qn GIF_SRC *.gif
	@mk-filelist -qn JPG_SRC *.jpeg *.jpg
	@mk-filelist -qn SVG_SRC *.svg
