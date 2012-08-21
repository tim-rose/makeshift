#
# PYTHON.MK --Rules for building PYTHON objects and programs.
#
# Contents:
# python-clean: --Remove script executables.
# python-toc:   --Build the table-of-contents for PYTHON-ish files.
# python-src:   --python-specific customisations for the "src" target.
# todo:         --Report unfinished work (identified by keyword comments)
#
# %.py:		--Rules for installing python scripts
#
PY_TRG = $(PY_SRC:%.py=%)

%:			%.py;	@$(INSTALL_SCRIPT) $(PYTHON_PATH) $? $@
$(bindir)/%:		%.py;	@$(INSTALL_SCRIPT) $(PYTHON_PATH) $? $@
$(libexecdir)/%:	%.py;	@$(INSTALL_SCRIPT) $(PYTHON_PATH) $? $@

pre-build:	src-var-defined[PY_SRC]
build:	$(PY_TRG)

#
# python-clean: --Remove script executables.
#
.PHONY: python-clean
clean:	python-clean
python-clean:
	$(RM) $(PY_TRG)

#
# python-toc: --Build the table-of-contents for PYTHON-ish files.
#
.PHONY: python-toc
toc:	python-toc
python-toc:
	@$(ECHO) "++ make[$@]@$$PWD"
	mk-toc $(PY_SRC)

#
# python-src: --python-specific customisations for the "src" target.
#
.PHONY:	python-src
src:	python-src
python-src:	
	$(ECHO) "++ make[$@]@$$PWD"
	@mk-filelist -qn PY_SRC *.py
#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: python-todo
todo:	python-todo
python-todo:
	@$(ECHO) "++ make[$@]@$$PWD"
	@$(GREP) -e TODO -e FIXME -e REVISIT $(PY_SRC) /dev/null || true
