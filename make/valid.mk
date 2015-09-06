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
# cmd-exists[%]:      --Test if a command exists.
# mkdir[%]:           --Create a directory.
#
# Remarks:
# The "valid" module is a library of validation tests in the form of
# make targets.  These are used by various pattern rules in the devkit
# build system.
#
# Example: the following definition will fail if the macro $(INPUT_FILES)
# is not defined, or if there is no command *my-frobnicate*:
#
# ```
# my-target: var-defined[INPUT_FILES] cmd-exists[frobnicate]
#         frobnicate $(INPUT_FILES) > $@
# ```
#
# Note that the target will fail anyway if *frobnicate* doesn't exist,
# and probably *frobnicate* will generate some error if the supplied
# $(INPUT_FILES) is empty, however with these dependencies the error
# messages will likely make more sense:
#
# ```
# Error: INPUT_FILES variable(s) not defined
# Error: command "frobnicate" does not exist
# ```
#
VAR_UNDEF = 'Error: %s variable(s) not defined\n'
#
# var-defined[%]: --Test that a variable is defined.
#
var-defined[%]:
	@if [ -z '$(value $*)' ]; then \
	    printf $(VAR_UNDEF) "$*"; \
	    false; \
	fi >&2
#
# src-var-defined[%]: --Test that a source variable is defined.
#
src-var-defined[%]:
	@if [ -z '$(value $*)' ]; then \
	    printf $(VAR_UNDEF) "$*"; \
	    echo 'run "make src" to define it'; \
	    false; \
	fi >&2
#
# absolute-path[%] --Test that a string defines an absolute file path.
#
var-absolute-path[%]:
	@case '$(value $*)' in \
	/*);; \
	*)  echo 'Error: \"$*\" ("$(value $*)") is not an absolute path'; \
	    false; \
	esac

#
# file-writable[%]: --Test if a file is writable
#
file-writable[%]:
	@if [ ! -w "$*" ]; then \
	    echo "Error: \"$*\" is not writable"; \
	    false; \
	fi

#
# file-exists[%]: --Test if a file exists.
#
file-exists[%]:
	@if [ ! -f "$*" ]; then \
	    echo "Error: file \"$*\" does not exist"; \
	    false; \
	fi

#
# dir-exists[%]: --Test if a directory exists.
#
dir-exists[%]:
	@if [ ! -d "$*" ]; then \
	    echo "Error: directory \"$*\" does not exist"; \
	    false; \
	fi

#
# cmd-exists[%]: --Test if a command exists.
#
cmd-exists[%]:
	@if  ! type "$*" >/dev/null 2>&1; then \
	    echo "Error: command \"$*\" does not exist"; \
	    false; \
	fi

#
# mkdir[%]: --Create a directory.
#
# Remarks:
# This rule doesn't work as a dependency in the simple sense, but is
# still useful as an abstraction to portably make a directory.
#
mkdir[%]:
	@if [ ! -d "$*" ]; then \
	    $(INSTALL_DIRECTORY) "$*"; \
	fi
