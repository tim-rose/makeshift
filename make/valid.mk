#
# VALID.MK --devkit/file-state validation targets.
#
# Contents:
# var-defined[%]:     --Test that a variable is defined.
# src-var-defined[%]: --Test that a source variable is defined.
# absolute-path[%]    --Test that a string defines an absolute file path.
# file-writable[%]:   --Test if a file is writable
# file-exists[%]:     --Test if a file exists.
# dir-exists[%]:      --Test if a directory exists.
# mkdir[%]:           --Create a directory if needed.
#
# Remarks:
# This file contains various validation tests of the makefile system
# in the form of make targets.
#
VAR_UNDEFINED = var_undefined() { \
	echo "Error: $$1 variable(s) not defined"; shift; \
	for msg in "$$@"; do echo "$$msg"; done; \
	false; \
    }; var_undefined
#
# var-defined[%]: --Test that a variable is defined.
#
var-defined[%]:
	@test -n '$(value $*)' || { $(VAR_UNDEFINED) "$*"; }

#
# src-var-defined[%]: --Test that a source variable is defined.
#
src-var-defined[%]:
	@test -n '$(value $*)' || \
	{ $(VAR_UNDEFINED) "$*" 'run "make src" to define it'; }

#
# absolute-path[%] --Test that a string defines an absolute file path.
#
var-absolute-path[%]:
	@case '$(value $*)' in \
	/*);; \
	*)  echo 'Error: $* ("$(value $*)") is not an absolute path'; \
	    false; \
	esac

#
# file-writable[%]: --Test if a file is writable
#
file-writable[%]:
	@if [ ! -w $* ]; then \
	    echo "Error: $* is not writable"; \
	    false; \
	fi

#
# file-exists[%]: --Test if a file exists.
#
file-exists[%]:
	@if [ ! -f $* ]; then \
	    echo "Error: file $* does not exist"; \
	    false; \
	fi

#
# dir-exists[%]: --Test if a directory exists.
#
dir-exists[%]:
	@if [ ! -d $* ]; then \
	    echo "Error: directory $* does not exist"; \
	    false; \
	fi

#
# mkdir[%]: --Create a directory if needed.
#
mkdir[%]:
	@if [ ! -d $* ]; then \
	    $(INSTALL_DIRECTORY) $*; \
	fi
