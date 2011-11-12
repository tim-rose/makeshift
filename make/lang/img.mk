#
# IMG.MK --Rules for installing and building image files
#
# Contents:
# img-src: --img-specific customisations for the "src" target.
#
IMG_SRC = $(PNG_SRC) $(GIF_SRC) $(JPG_SRC)

$(wwwdir)/%.png:	%.png;	$(INSTALL_DATA) $? $@
$(wwwdir)/%.gif:	%.gif;	$(INSTALL_DATA) $? $@
$(wwwdir)/%.jpeg:	%.jpeg;	$(INSTALL_DATA) $? $@
$(wwwdir)/%.jpg:	%.jpg;	$(INSTALL_DATA) $? $@

#
# img-src: --img-specific customisations for the "src" target.
#
src:	img-src
.PHONY:	img-src
img-src:	
	@$(ECHO) "++ make[$@]@$$PWD"
	@mk-filelist -qn PNG_SRC *.png
	@mk-filelist -qn GIF_SRC *.gif
	@mk-filelist -qn JPG_SRC *.jpeg *.jpg

