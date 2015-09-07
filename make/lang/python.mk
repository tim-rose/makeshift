#
# PYTHON.MK --Rules for building PYTHON objects and programs.
#
# Contents:
# install-python:     --Install python as executables.
# install-python-lib: --Install python as library modules.
# clean-python:       --Remove script executables.
# toc-python:         --Build the table-of-contents for python files.
# src-python:         --specific-python customisations for the "src" target.
# todo-python:        --Report unfinished work (identified by keyword comments)
# lint-python:        --Run a static analyser over the PY_SRC.
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
$(pythonlibdir)/%.py:	%.py;	$(INSTALL_FILE) $? $@

pre-build:	src-var-defined[PY_SRC]
build-python:	$(PY_TRG)

#
# install-python: --Install python as executables.
#
install-python: $(bindir)/$(PY_SRC:%.py=%)

#
# install-python-lib: --Install python as library modules.
#
install-python: $(pythonlibdir)/$(PY_SRC:%.py=%)

#
# clean-python: --Remove script executables.
#
clean:	clean-python
distclean:	clean-python

clean-python:
	$(RM) $(PY_SRC:%.py=%.py[co])

#
# toc-python: --Build the table-of-contents for python files.
#
toc:	toc-python
toc-python:
	$(ECHO_TARGET)
	mk-toc $(PY_SRC)

#
# src-python: --specific-python customisations for the "src" target.
#
src:	src-python
src-python:
	$(ECHO_TARGET)
	@mk-filelist -qn PY_SRC *.py
#
# todo-python: --Report unfinished work (identified by keyword comments)
#
todo:	todo-python
todo-python:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(PY_SRC) /dev/null || true

#
# lint-python: --Run a static analyser over the PY_SRC.
#
# Remarks:
# There are several static analysers for python, for now I'm using pep8 with
# relaxed line-length restrictions.  The following errors are excluded:
#
# * E402 module level import not at top of file
# * E721 do not compare types, use 'isinstance()'
#
lint:	lint-python
lint-python:    cmd-exists[pep8]
	$(ECHO_TARGET)
	-pep8 --max-line-length=110 --ignore=E402,E721 $(PY_SRC)

tidy:	tidy-python
tidy-python:    cmd-exists[autopep8]
	$(ECHO_TARGET)
	autopep8 --in-place --max-line-length=110 --ignore=E402,E721 $(PY_SRC)
