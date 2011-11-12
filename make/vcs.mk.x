#
# VCS.MK --Make targets to interact with the version-control system.
#
# Contents:
#
# Remarks:
# These targets are hardcoded to SVN at the moment.
# Although not spectacularly useful in their own right, the idea
# is that they can interact recursively with a "master" make that
# will semi-recursively apply the targets into a, um, semi-transaction.
#

#
# status: --report on the status of the source files in this project.
#
.PHONY:	status
status:		;	svn status

#
# diff: --report on unchecked-in changes to source files.
#
.PHONY:	diff
diff:		;	svn diff
diff@%:		;	svn diff -r $*

#
# checkin: --report on unchecked-in changes to source files.
#
.PHONY:	checkin
checkin:	;	svn checkin
checkin[%]:	;	svn checkin -m '$*'


