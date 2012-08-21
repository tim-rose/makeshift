#
# DATABASE.MK --Default targets for database-related projects.
#
# Contents:
# %.db:      --Make a database from an sql file.
# distclean: --Cleanup the test database for this database.
#
# Remarks:
# This file defines special targets for setting up and tearing down
# databases, usually for testing/development purposes.
#
DB_INIT = . db.shl $(DATABASE)

DB_LOAD_DATA = \
	for t in data/*.csv; do \
	    db_load $$(basename $$t .csv) $$t; \
	done
#
# %.db: --Make a database from an sql file.
#
# Remarks:
# This target still assumes/makes a sqlite target.  I need to fix this
# with some db_create/db_drop style functions in the db database...
#
%.db: var-defined[DATABASE] %.sql
	$(DB_INIT); db_create $(DATABASE) || $(RM) $@
	$(DB_INIT); _db_convert_sql < $(DATABASE).sql | db_exec || $(RM) $@
	$(DB_INIT); $(DB_LOAD_DATA)
	touch $@

pre-build:	var-defined[DATABASE]
pre-test:	$(DATABASE).db

#
# distclean: --Cleanup the test database for this database.
# 
distclean:	distclean-database
.PHONY:		distclean-database
distclean-database:
	$(RM) $(DATABASE).db
