#
# PYTHON.MK --Rules for building PYTHON objects and programs.
#
# Contents:
# build-python:       --Build the python source code as individual executables.
# install-python:     --Install python as executables.
# install-python-lib: --Install python as library modules.
# clean:              --Remove python executables.
# toc:                --Build the table-of-contents for python files.
# src:                --define the PY_SRC variable.
# todo:               --Report unfinished work (identified by keyword comments)
# lint:               --Run a static analyser over the PY_SRC.
# +version:           --Report details of tools used by python.
#
# See Also:
# Exercises in Programming Style, Cristina Videira Lopes
# https://github.com/crista/exercises-in-programming-style
#
.PHONY: $(recursive-targets:%=%-python)


ifdef autosrc
    LOCAL_PY_SRC := $(wildcard *.py)

    PY_SRC ?= $(LOCAL_PY_SRC)
endif

PY_LINT ?= pylint
PY_TIDY ?= autopep8

#
# %.py:		--Rules for installing python scripts
#
pythonlibdir      = $(exec_prefix)/lib/python/$(subdir)
PY_TRG = $(archdir)/$(PY_SRC:%.py=%)
SET_VERSION = $(SED) -e 's/\<VERSION\>/$(VERSION)/'

$(archdir)/%:		%.py | $(archdir)
	$(SET_VERSION) $? >$@
	$(CHMOD) +x $@

$(pythonlibdir)/%.py:	%.py;	$(INSTALL_DATA) $? $@
$(pythonlibdir)/%.py:	$(gendir)/%.py;	$(INSTALL_DATA) $? $@

#
# build-python: --Build the python source code as individual executables.
#
# Remarks:
# This isn't built by default because it may be a directory of library code.
build-python:	$(PY_TRG)

#
# install-python: --Install python as executables.
#
install-python: $(PY_SRC:%.py=$(bindir)/%)
	 $(ECHO_TARGET)

uninstall-python:
	$(ECHO_TARGET)
	$(RM) $(PY_SRC:%.py=$(bindir)/%)
	$(RM) $(PY_SRC:%.py=$(bindir)/__pycache__/%.pyc)
	$(RMDIR) $(bindir)/__pycache__ $(bindir)

#
# install-python-lib: --Install python as library modules.
#
.PHONY: install-python-lib uninstall-python-lib
install-python-lib: $(PY_SRC:%.py=$(pythonlibdir)/%.py)
	$(ECHO_TARGET)

uninstall-python-lib:
	$(ECHO_TARGET)
	$(RM) $(PY_SRC:%.py=$(pythonlibdir)/%.py)
	$(RM) $(PY_SRC:%.py=$(pythonlibdir)/__pycache__/%.pyc)
	$(RMDIR) $(pythonlibdir)/__pycache__ $(pythonlibdir)

#
# clean: --Remove python executables.
#
clean:	clean-python
distclean:	clean-python

clean-python:
	$(RM) -r __pycache__ $(PY_SRC:%.py=%.py[co]) $(PY_TRG)

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
	$(Q)mk-filelist -f $(MAKEFILE) -qn PY_SRC *.py
#
# todo: --Report unfinished work (identified by keyword comments)
#
todo:	todo-python
todo-python:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(PY_SRC) /dev/null ||:

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
# REVISIT: make this more customisable...
#
lint:	lint-python
lint-python:	| cmd-exists[$(PY_LINT)] var-defined[PY_SRC]
	$(ECHO_TARGET)
	-$(PY_LINT) --max-line-length=100 --ignore=E402,E721 $(PY_SRC)

lint[%.py]:	| cmd-exists[$(PY_LINT)] var-defined[PY_SRC]
	$(ECHO_TARGET)
	-$(PY_LINT) --max-line-length=100 --ignore=E402,E721 $*.py

tidy:	tidy-python
tidy-python: 	| cmd-exists[$(PY_TIDY)] var-defined[PY_SRC]
	$(ECHO_TARGET)
	$(PY_TIDY) --in-place --max-line-length=100 --ignore=E402,E721 $(PY_SRC)

tidy[%.py]:	| cmd-exists[$(PY_TIDY)]
	$(ECHO_TARGET)
	$(PY_TIDY) --in-place --max-line-length=100 --ignore=E402,E721 $*.py

#
# +version: --Report details of tools used by python.
#
+version: cmd-version[python] \
	cmd-version[$(PY_LINT)] cmd-version[$(PY_TIDY)]
