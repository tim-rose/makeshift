#
# VCX.MK --Rules for dealing with Microsoft VCXPROJ files.
#
# Contents:
# build: --delegate build target to MSBuild.
# clean: --delegate clean target to MSClean.
# src:   --Update the VCX_SRC macro.
#
# Remarks:
# It's crazy, but it just might work.
#
.PHONY: $(recursive-targets:%=%-vcx)

MSB_OPTS = /nologo /maxcpucount

ifdef autosrc
    LOCAL_VCX_SRC := $(wildcard *.vcx)

    VCX_SRC ?= $(LOCAL_VCX_SRC)
endif

#
# build: --delegate build target to MSBuild.
#
build: build-vcx
build-vcx: $(VCX_SRC:%=build-vcx[%])
build-vcx[%]:
	MSBuild.exe /target:Build $(MSB_OPTS) $(CONFIG:%=/property:Configuration=%)

#
# clean: --delegate clean target to MSClean.
#
clean: clean-vcx
clean-vcx: $(VCX_SRC:%=clean-vcx[%])
clean-vcx[%]:
	MSBuild.exe /target:Clean $(MSB_OPTS) $(CONFIG:%=/property:Configuration=%)

#
# src: --Update the VCX_SRC macro.
#
src:	src-vcx
src-vcx:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn VCX_SRC *.vcxproj
