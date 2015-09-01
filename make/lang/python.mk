#
# PYTHON.MK --Rules for building PYTHON objects and programs.
#
# Contents:
# install-python:     --Install python as executables.
# install-python-lib: --Install python as library modules.
# clean-python:       --Remove script executables.
# toc-python:         --Build the table-of-contents for ish-PYTHON files.
# src-python:         --specific-python customisations for the "src" target.
# todo-python:        --Report unfinished work (identified by keyword comments)
#

#
# %.py:		--Rules for installing python scripts
#
pythonlibdir      = $(exec_prefix)/lib/python/$(subdir)
PY_TRG = $(PY_SRC:%.py=%)

%:			%.py;	$(CP) $*.py $@ && $(CHMOD) +x $@
$(pythonlibdir)/%.py:	%.py;	$(INSTALL_FILE) $? $@

pre-build:	src-var-defined[PY_SRC]
build-python:	$(PY_TRG)

#
# install-python: --Install python as executables.
#
.PHONY: install-python
install-python: $(bindir)/$(PY_SRC:%.py=%)

#
# install-python-lib: --Install python as library modules.
#
.PHONY: install-python-lib
install-python: $(pythonlibdir)/$(PY_SRC:%.py=%)

#
# clean-python: --Remove script executables.
#
.PHONY: clean-python
clean:	clean-python
clean-python:
	$(RM) $(PY_SRC:%.py=%.py[co])

#
# toc-python: --Build the table-of-contents for ish-PYTHON files.
#
.PHONY: toc-python
toc:	toc-python
toc-python:
	$(ECHO_TARGET)
	mk-toc $(PY_SRC)

#
# src-python: --specific-python customisations for the "src" target.
#
.PHONY:	src-python
src:	src-python
src-python:
	$(ECHO_TARGET)
	@mk-filelist -qn PY_SRC *.py

#
# todo-python: --Report unfinished work (identified by keyword comments)
#
.PHONY: todo-python
todo:	todo-python
todo-python:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(PY_SRC) /dev/null || true
