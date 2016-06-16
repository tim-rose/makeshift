#
# TEX.MK --Build rules for handling TeX documents.
#
# Contents:
# clean:     --Clean TeX intermediate files.
# distclean: --Clean TeX derived PDF files.
# src:       --Update the definition of TEX_SRC.
# todo:      --Report unfinished work in tex code.
#
.PHONY: $(recursive-targets:%=%-tex)

ifdef AUTOSRC
    LOCAL_TEX_SRC := $(wildcard *.tex)
    TEX_SRC ?= $(wildcard *.tex)
endif

%.pdf:	%.dvi;	dvipdf $*.dvi
%.dvi:	%.tex;  latex $*.tex

TEX_DVI = $(TEX_SRC:%.tex=%.dvi)
TEX_AUX = $(TEX_SRC:%.tex=%.aux)
TEX_LOG = $(TEX_SRC:%.tex=%.log)
TEX_PDF = $(TEX_SRC:%.tex=%.pdf)

build:	$(TEX_PDF)

#
# clean: --Clean TeX intermediate files.
#
clean:	clean-tex
clean-tex:
	$(ECHO_TARGET)
	$(RM) $(TEX_DVI) $(TEX_AUX) $(TEX_LOG)

#
# distclean: --Clean TeX derived PDF files.
#
distclean:	clean-tex distclean-tex
distclean-tex:
	$(ECHO_TARGET)
	$(RM) $(TEX_PDF)

#
# src: --Update the definition of TEX_SRC.
#
src:	src-tex
src-tex:
	$(ECHO_TARGET)
	@mk-filelist -qn TEX_SRC *.tex
#
# todo: --Report unfinished work in tex code.
#
todo:	todo-tex
todo-tex:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) \
	    $(SH_SRC) $(SHL_SRC) $(AWK_SRC) $(SED_SRC) /dev/null || true
