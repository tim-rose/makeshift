#
# C++.MK --Rules for building C++ objects and programs.
#
# Contents:
# main:    --rules for building executables from a file containing "main()".
# %.o:     --Compile a C++ file into an arch-specific sub-directory.
# %.hpp:   --Rules for installing header files.
# build:   --cxx-specific customisations for the "build" target.
# clean:   --cxx-specific customisations for the "clean" target.
# tidy:    --cxx-specific customisations for the "tidy" target.
# cxx-toc: --Build the table-of-contents for CXX-ish files.
# cxx-src: --cxx-specific customisations for the "src" target.
# tags:    --Build vi, emacs tags files.
# todo:    --Report unfinished work (identified by keyword comments)
#
-include $(CXX_SRC:%.cpp=$(archdir)/%-depend.mk)

C_DEFS	= $(C_OS_DEFS) $(C_ARCH_DEFS) -D__$(OS)__ -D__$(ARCH)__
CXX_WARN_FLAGS  = -O -pedantic -Wall \
        -Wpointer-arith -Wwrite-strings \
        -Wcast-align -Wshadow -Wredundant-decls \
        -Wuninitialized -Wunused-parameter
CXX_VIS_CFLAGS	= -std=c++0x $(CXX_DEFS) $(CXX_OS_FLAGS) $(CXX_ARCH_FLAGS) $(CFLAGS)
CXX_ALL_CFLAGS	= $(CXX_VIS_CFLAGS) $(CXX_WARN_FLAGS)

CPPFLAGS 	= -I. -I$(includedir)
LDFLAGS		= -L$(libdir) $(CFLAGS)

CXX_OBJ	= $(CXX_SRC:%.cpp=$(archdir)/%.o)
CXX_MAIN = $(CXX_MAIN_SRC:%.cpp=$(archdir)/%)

#
# main: --rules for building executables from a file containing "main()".
#
$(archdir)/%: %.cpp $(archdir)/%.o
	@echo $(CXX) $(CPPFLAGS) $(CXX_VIS_CFLAGS) $(LDFLAGS) $(archdir)/$*.o \
		$(LOADLIBES) $(LDLIBS)
	@$(CXX) -o $@ $(CXX_ALL_CFLAGS) $(LDFLAGS) $(archdir)/$*.o \
		$(LOADLIBES) $(LDLIBS)
#
# %.o: --Compile a C++ file into an arch-specific sub-directory.
#
$(archdir)/%.o: %.cpp mkdir[$(archdir)]
	$(ECHO_TARGET)
	@echo $(CXX) $(CPPFLAGS) $(CXX_VIS_CFLAGS) -c -o $@ $<
	@$(CXX) $(CPPFLAGS) $(CXX_ALL_CFLAGS) -c -o $@ \
		-MMD -MF $(archdir)/$*-depend.mk $<	

#
# %.hpp: --Rules for installing header files.
#
$(includedir)/%.hpp:	%.hpp;		$(INSTALL_FILE) $? $@

#
# build: --cxx-specific customisations for the "build" target.
#
pre-build:	src-var-defined[CXX_SRC]
build:	$(CXX_OBJ) $(CXX_MAIN)

#
# clean: --cxx-specific customisations for the "clean" target.
#
clean:	cxx-clean
.PHONY:	cxx-clean
cxx-clean:
	$(ECHO_TARGET)
	$(RM) $(archdir)/*.o $(CXX_MAIN)

#
# tidy: --cxx-specific customisations for the "tidy" target.
#
tidy:	cxx-tidy
.PHONY:	cxx-tidy
cxx-tidy:
	$(ECHO_TARGET)
	INDENT_PROFILE=$(DEVKIT_HOME)/etc/.indent.pro indent $(HXX_SRC) $(CXX_SRC)
#
# cxx-toc: --Build the table-of-contents for CXX-ish files.
#
.PHONY: cxx-toc
toc:	cxx-toc
cxx-toc:
	$(ECHO_TARGET)
	mk-toc $(HXX_SRC) $(CXX_SRC)

#
# cxx-src: --cxx-specific customisations for the "src" target.
#
src:	cxx-src
.PHONY:	cxx-src
cxx-src:	
	$(ECHO_TARGET)
	@mk-filelist -qn CXX_SRC *.cpp
	@mk-filelist -qn CXX_MAIN_SRC \
		$$(grep -l '^ *int *main(' *.cpp 2>/dev/null)
	@mk-filelist -qn HXX_SRC *.hpp

#
# tags: --Build vi, emacs tags files.
# 
.PHONY: cxx-tags
tags:	cxx-tags
cxx-tags:
	$(ECHO_TARGET)
	ctags 	$(HXX_SRC) $(CXX_SRC) && \
	etags	$(HXX_SRC) $(CXX_SRC); true

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: cxx-todo
todo:	cxx-todo
cxx-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(HXX_SRC) $(CXX_SRC) /dev/null || true
