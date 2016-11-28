#
# PYTHON.MK --Rules for building PYTHON objects and programs.
#
# Contents:
# install-python:     --Install python as executables.
# install-python-lib: --Install python as library modules.
# clean:              --Remove python executables.
# toc:                --Build the table-of-contents for python files.
# src:                --define the PY_SRC variable.
# todo:               --Report unfinished work (identified by keyword comments)
# lint:               --Run a static analyser over the PY_SRC.
#
# See Also:
# Exercises in Programming Style, Cristina Videira Lopes
# https://github.com/crista/exercises-in-programming-style
#
.PHONY: $(recursive-targets:%=%-python)

#
# %.py:		--Rules for installing python scripts
#
pythonlibdir      = $(exec_prefix)/lib/python/$(subdir)
PY_TRG = $(PY_SRC:%.py=%)

%:			%.py;	$(CP) $*.py $@ && $(CHMOD) +x $@
$(bindir)/%:		%.py;	$(INSTALL_SCRIPT) $*.py $@
$(pythonlibdir)/%.py:	%.py;	$(INSTALL_FILE) $? $@
$(pythonlibdir)/%.py:	$(gendir)/%.py;	$(INSTALL_FILE) $? $@

build-python:	$(PY_TRG)

#
# install-python: --Install python as executables.
#
install-python: $(PY_SRC:%.py=$(bindir)/%)
	 $(ECHO_TARGET)

uninstall-python:
	$(ECHO_TARGET)
	$(RM) $(PY_SRC:%.py=$(bindir)/%)
	$(RMDIR) -p $(bindir) 2>/dev/null || true

#
# install-python-lib: --Install python as library modules.
#
.PHONY: install-python-lib uninstall-python-lib
install-python-lib: $(PY_SRC:%.py=$(pythonlibdir)/%.py)
	$(ECHO_TARGET)

uninstall-python-lib:
	$(ECHO_TARGET)
	$(RM) $(PY_SRC:%.py=$(pythonlibdir)/%.py)
	$(RMDIR) -p $(pythonlibdir) 2>/dev/null || true

#
# clean: --Remove python executables.
#
clean:	clean-python
distclean:	clean-python

clean-python:
	$(RM) -r __pycache__ $(PY_SRC:%.py=%.py[co]) $(PY_SRC:%.py=%)

#
# toc: --Build the table-of-contents for python files.
#
toc:	toc-python
toc-python:	var-defined[PY_SRC]
	$(ECHO_TARGET)
	mk-toc $(PY_SRC)

#
# src: --define the PY_SRC variable.
#
src:	src-python
src-python:
	$(ECHO_TARGET)
	@mk-filelist -qn PY_SRC *.py
#
# todo: --Report unfinished work (identified by keyword comments)
#
todo:	todo-python
todo-python:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(PY_SRC) /dev/null || true

#
# lint: --Run a static analyser over the PY_SRC.
#
# Remarks:
# There are several static analysers for python, for now I'm using pep8 with
# relaxed line-length restrictions.  The following errors are excluded:
#
# * E402 module level import not at top of file
# * E721 do not compare types, use 'isinstance()'
#
lint:	lint-python
lint-python:	| cmd-exists[pep8] var-defined[PY_SRC]
	$(ECHO_TARGET)
	-pep8 --max-line-length=110 --ignore=E402,E721 $(PY_SRC)

lint[%.py]:	| cmd-exists[pep8] var-defined[PY_SRC]
	$(ECHO_TARGET)
	-pep8 --max-line-length=110 --ignore=E402,E721 $*.py

tidy:	tidy-python
tidy-python: 	| cmd-exists[autopep8] var-defined[PY_SRC]
	$(ECHO_TARGET)
	autopep8 --in-place --max-line-length=110 --ignore=E402,E721 $(PY_SRC)

tidy[%.py]:	| cmd-exists[autopep8]
	$(ECHO_TARGET)
	autopep8 --in-place --max-line-length=110 --ignore=E402,E721 $*.py
