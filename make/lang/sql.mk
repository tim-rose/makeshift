#
# SQL.MK --Rules for dealing with SQL files.
#
# Contents:
# sql-toc: --Build the table-of-contents for shell, awk files.
# sql-src: --sql-specific customisations for the "src" target.
# todo:    --Report unfinished work (identified by keyword comments)
#

pre-build:	src-var-defined[SQL_SRC]

#
# sql-toc: --Build the table-of-contents for shell, awk files.
#
.PHONY: sql-toc
toc:	sql-toc
sql-toc:
	$(ECHO_TARGET)
	mk-toc $(SQL_SRC)
#
# sql-src: --sql-specific customisations for the "src" target.
#
src:	sql-src
.PHONY:	sql-src
sql-src:	
	$(ECHO_TARGET)
	@mk-filelist -qn SQL_SRC *.sql

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: sql-todo
todo:	sql-todo
sql-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(SQL_SRC) /dev/null || true
