#
# PROTOBUF.MK --Rules for building compiling protobuf protocols.
#
# Contents:
# %.pb.cc: --build the C++ stubs from a ".proto" file.
# %.py:    --Build the python stubs from a ".proto" file.
# build:   --Build the protobuf files.
# clean:   --Remove objects and intermediates created from protobuf files.
# src:     --Update the PROTOBUF_SRC macro.
# todo:    --Find "unfinished work" comments in protobuf files.
#
# Remarks:
# The protobuf module adds support for building Protobuf-related software.
# It defines some pattern rules for compiling ".proto" files into
# C++, python (but not java, yet).
#
.PHONY: $(recursive-targets:%=%-protobuf)

PROTOC	?= protoc
PROTOBUF_FLAGS = $(TARGET.PROTOBUF_FLAGS) $(LOCAL.PROTOBUF_FLAGS) \
    $(PROJECT.PROTOBUF_FLAGS) $(ARCH.PROTOBUF_FLAGS) $(OS.PROTOBUF_FLAGS)

C++_SUFFIX ?= cc
H++_SUFFIX ?= h

PROTOBUF_C++_TRG = $(PROTOBUF_SRC:%.proto=$(archdir)/%.pb.$(C++_SUFFIX))
PROTOBUF_H++_TRG = $(PROTOBUF_SRC:%.proto=$(archdir)/%.pb.$(H++_SUFFIX))
PROTOBUF_PY_TRG = $(PROTOBUF_SRC:%.proto=$(archdir)/%.py)
PROTOBUF_TRG  = $(PROTOBUF_C++_TRG) $(PROTOBUF_H++_TRG) $(PROTOBUF_PY_TRG)

.PRECIOUS: $(PROTOBUF_TRG)

PROTOBUF_OBJ = $(PROTOBUF_C++_TRG:%.$(C++_SUFFIX)=%.o)

#
# %.pb.cc: --build the C++ stubs from a ".proto" file.
#
$(archdir)/%.pb.$(C++_SUFFIX) $(archdir)/%.pb.$(H++_SUFFIX):	%.proto
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	$(PROTOC) $(PROTOBUF_FLAGS) --cpp_out=$(archdir) $<
	cd $(archdir) ; \
	if [ "$(H++_SUFFIX)" != "h" ]; then \
	    $(MV) $*.pb.h $*.pb.$(H++_SUFFIX); \
	    $(CP) $*.pb.cc $*.pb.cc.bak; \
	    sed -e "s/$*\.pb\.h/$*.pb.$(H++_SUFFIX)/" <$*.pb.cc.bak >$*.pb.cc; \
	    $(RM)  $*.pb.cc.bak; \
	fi
	cd $(archdir) ; \
	if [ "$(C++_SUFFIX)" != "cc" ]; then \
	    $(MV) $*.pb.cc $*.pb.$(C++_SUFFIX); \
	fi

#
# %.py: --Build the python stubs from a ".proto" file.
#
$(archdir)/%.py:	%.proto
	$(ECHO_TARGET)
	@mkdir -p $(archdir)
	$(PROTOC) $(PROTOBUF_FLAGS) --python_out=$(archdir) $<
	cd $(archdir); $(MV) $*_pb2.py $*.py

#
# build: --Build the protobuf files.
#
build:	$(PROTOBUF_OBJ)

#
# clean: --Remove objects and intermediates created from protobuf files.
#
clean:	clean-protobuf
clean-protobuf:
	$(ECHO_TARGET)
	$(RM) $(PROTOBUF_TRG) $(PROTOBUF_OBJ)

#
# src: --Update the PROTOBUF_SRC macro.
#
src:	src-protobuf
src-protobuf:
	$(ECHO_TARGET)
	@mk-filelist -qn PROTOBUF_SRC *.proto

#
# todo: --Find "unfinished work" comments in protobuf files.
#
todo:	todo-protobuf
todo-protobuf:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(PROTOBUF_SRC) /dev/null || true
