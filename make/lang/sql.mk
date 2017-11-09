#
# SQL.MK --Rules for dealing with SQL files.
#
# Contents:
# %.sql:       --Rules for installing SQL scripts into libdir
# install-sql: --Install SQL files.
# toc:         --Build the table-of-contents for SQL files.
# src:         --Update the SQL_SRC macro.
# todo:        --Report unfinished work in work SQL files.
#
.PHONY: $(recursive-targets:%=%-sql)

ifdef autosrc
    LOCAL_SQL_SRC := $(wildcard *.sql)

    SQL_SRC ?= $(LOCAL_SQL_SRC)
endif

sqllibdir	:= $(exec_prefix)/lib/sql/$(subdir)

#
# %.sql: --Rules for installing SQL scripts into libdir
#
$(sqllibdir)/%.sql:	%.sql;	$(INSTALL_DATA) $? $@

#
# install-sql: --Install SQL files.
#
install-sql:    $(SQL_SRC:%=$(sqllibdir)/%); $(ECHO_TARGET)
uninstall-sql:
	$(ECHO_TARGET)
	$(RM) $(SQL_SRC:%=$(sqllibdir)/%)
	$(RMDIR) -p $(sqllibdir) 2>/dev/null || true

#
# toc: --Build the table-of-contents for SQL files.
#
toc:	toc-sql
toc-sql:
	$(ECHO_TARGET)
	mk-toc $(SQL_SRC)

#
# src: --Update the SQL_SRC macro.
#
src:	src-sql
src-sql:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn SQL_SRC *.sql

#
# todo: --Report unfinished work in work SQL files.
#
todo:	todo-sql
todo-sql:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(SQL_SRC) /dev/null || true
