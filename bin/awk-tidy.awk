#!/usr/bin/awk -f
#
#@ This program came from: ftp://ftp.armory.com/pub/scripts/fmtawksh
#@ Look there for the latest version.
#@ If you don't find it, look through http://www.armory.com/~ftp/
#
# @(#) fmtawksh 1.2 1996-04-16
# 1995-04-25 john h. dubois iii (john@armory.com)
# 1995-05-22 Use stack library.  Try to keep comment/block pairs together.
#            Added all options.
# 1996-04-16 Read from /dev/tty for interactive tty input if no filenames.
#            Make filename in footer work correctly again.
#            Changed p option to n; added new p option.
#            Exit if q is typed.

# Break awk programs up into blocks, inter-block comments, and any whitespace
# that comes between them.  Try to avoid splitting these; try to keep comments
# with the block that follows it.
# Leading empty blocks (blank lines at the top of the page) are not printed.

BEGIN {
    Debug = 0
    PagePos = 0
    PageLen = 66
    FormFeed = sprintf("%c",12)	# formfeed
    Name = "fmtawksh"
    Usage = \
    "Usage: " Name " [-whinsax] [-l<lines>] [-p<page-ranges>] [file ...]"
    ARGC = Opts(Name,Usage,"whinsaxtl>",0)
    if ("h" in Options) {
	printf \
"%s: Format awk, sh, and ksh scripts for printing.\n"\
Usage "\n"\
"%s tries to avoid splitting modules between pages.  Function and\n"\
"interfunction blocks are pushed to the start of a new page if it will\n"\
"prevent them from being split.  If an interfunction block is followed by a\n"\
"function block without any intervening whitespace, %s will try to keep\n"\
"them together, splitting them between pages only if they will not fit on a\n"\
"page together.  Thus, if a function is preceded by comments regarding it,\n"\
"there should be no blank lines within the comments, so that %s will treat\n"\
"the entire comment section as being associated with the function block. \n"\
"If there are blank lines within the comments, put a pound sign on each of\n"\
"the blank lines so that they will not be empty.\n"\
"The start and end of a function block are recognized by simple pattern\n"\
"tests which will fail in some circumstances.  A function block begins with\n"\
"a line that consists of any amount of whitespace, followed by either: \n"\
"* The word 'function' followed by end of line or whitespace (ksh and awk\n"\
"  functions).\n"\
"* A legal identifier followed by a pair of parentheses (sh functions).\n"\
"* A non-commented line that includes an open-brace followed by\n"\
"  end-of-line or the beginning of a comment (awk pattern block).\n"\
"A function block ends when a close-brace is found at the start of a line.\n"\
"An interfunction block is anything that is outside of a function block.\n"\
"Multiple blank lines are squeezed to one and trailing spaces are removed.\n"\
"Options:\n"\
"-h: Print this help.\n"\
"-i: Wait for return to be pressed after printing each page.  This option\n"\
"    requires that filenames be given, rather than letting %s read the\n"\
"    standard input.\n"\
"-n: Print a footer that includes the page number and filename.\n"\
"-l: Set the number of lines per page (default: %d)\n"\
"-w: Complain about lines in an awk program if their type cannot be\n"\
"    determined (specifically, lines that do not appear to be comments nor\n"\
"    part of an awk-block).\n"\
"-a: Recognize only awk function blocks.\n"\
"-s: Recognize only sh/ksh function blocks.\n"\
"-x: Print debugging information.\n",
Name,Name,Name,Name,Name,PageLen
	exit(0)
    }
    Debug = "x" in Options
    if ("l" in Options)
	PageLen = Options["l"]
    # Test exercises most of the code but does not add any formfeeds or
    # delete blank lines, etc., so the output can be compared to the input to
    # test this program.
    Test = "t" in Options
    Quiet = !("w" in Options)
    if (Interactive = ("i" in Options))
	ttyfile = ARGC < 2 ? "/dev/tty" : "/dev/stdin"
    if (Footer = "n" in Options)
	PageLen -= 2

    FPat = "^[ \t]*(function($|[ \t])"
    if (!("a" in Options))
	# Add sh function pattern
	FPat = FPat "|[a-zA-Z_][a-zA-Z0-9_]*[ \t]*\\([ \t]*\\)"
    if (!("s" in Options))
	# Add awk pattern block pattern
	FPat = FPat "|[^#].*{[ \t]*(#|$)" #}pair match for preceding open-brace
    FPat = FPat ")"
    if (Debug)
	printf "Function start pattern: %s\n",FPat > "/dev/stderr"
    if (ARGC < 2)
	ProcFile("/dev/stdin")
    else
	for (i = 1; i < ARGC; i++)
	    ProcFile(ARGV[i])
    if (PagePos != 0)
	ff(PagePos)
}

# Sets globals: FILENAME
function ProcFile(InFile) {
    FILENAME = InFile
    if (Debug)
	print "Processing file: " InFile > "/dev/stderr"
    while (NumLines = GetBlock(InFile)) {
	if (!Test && PagePos == 0 && Block == "") # Discard leading blank lines
	    continue
	if (NumLines < 0) {
	    # This is a comment block and the next block is a function.
	    # Read next block to determine if we can keep the function together
	    # with the comments that precede it.
	    NumLines = -NumLines	# Determine real number of lines
	    CurBlock = Block		# Save current block
	    # Since this block is followed by a function block, we are
	    # guaranteed that another block can be gotten, and that it will
	    # have a positive return value.
	    NextLines = GetBlock(InFile)
	    if ((NumLines + NextLines) <= PageLen) {
		# This block and the next will fit on a page; conglomerate
		# them so that the rest of the code will have to treat them
		# as a single unit.
		Block = CurBlock "\n" Block
		NumLines += NextLines
		if (Debug)
		    print "Conglomerated comment+function block." \
		    > "/dev/stderr"
	    }
	    else {
		# This block and the next won't fit on a single page, so don't
		# try to keep them together.  Push the next block back so it
		# will be read next time.
		if (Debug)
		    printf \
		    "Comment+function won't fit on page (%d+%d > %d);\n"\
		    "pushing function to next page.\n",
		    NumLines,NextLines,PageLen > "/dev/stderr"
		PushBlock(NextLines,Block)
		Block = CurBlock
	    }
	}
	CurPagePos = PagePos	# Save page pos for use by footer function
	PagePos += NumLines	# Where will we be?
	if (PagePos <= PageLen) {	# Block will fit on this page
	    print Block
	    # If block exactly reached the end of page...
#	    if (PagePos == PageLen) {
#		PagePos = 0
#		ff(PagePos)
#	    }
	}
	else {
	    # If block won't fit on this page, but will fit on one page,
	    # print a formfeed first to push out the current page, so that
	    # the block will be printed on the next page.
	    if (NumLines <= PageLen) {
		ff(CurPagePos)
		PagePos = NumLines
	    }
	    if (Block == "")
		# If blank block, we know we did a formfeed, since a single
		# line will always fit on a page.
		# So, don't print the block, and set page pos to 0.
		PagePos = 0
	    else {
		if ((Interactive || Footer) && NumLines > PageLen)
		    SplitBlock(Block,CurPagePos,PageLen)
		else
		    print Block
		PagePos %= PageLen
	    }
	}
    }
}

# Split a block that would span multiple pages so that we can put footers at
# the bottom of each page.
function SplitBlock(Block,PagePos,PageLen,  Num,i) {
    Num = split(Block,Lines,"\n")
    for (i = 1; i <= Num; i++) {
	if (PagePos == PageLen) {
	    ff(PagePos)
	    PagePos = 0
	}
	print Lines[i]
	PagePos++
    }
}

# Print string s centered on page.
function Center(s) {
    return sprintf("%" int((80-length(s))/2) "s%s","",s)
}

# Print a formfeed.  If printing page numbers, print newlines to get to the
# bottom of the page and then print the filename/page number, then the
# formfeed.
function ff(PagePos) {
    if (!Test) {
	if (Footer) {
	    while (PagePos++ < PageLen)
		print ""
	    # Don't print trailing newline, so that we can print a formfeed
	    # even when doing footer printing.  This will hopefully limit the
	    # extent of erroneous printing if page position gets out of sync.
	    printf "\n%s",Center(sprintf("Page %d of %s",++PageNum,
	    FILENAME == "/dev/stdin" ? "stdin" : FILENAME))
	}
	if (Interactive) {
	    if ((getline < ttyfile) != 1) {
		printf "Bad read from %s.  Exiting.\n",ttyfile > "/dev/stderr"
		exit 1
	    }
	    if ($0 ~ /^[qQ]/) {
		print ""
		exit 0
	    }
	}
	printf "%s",FormFeed
    }
}

# Get next block.  A block is a function block (which may contain blank lines),
# or a text section (generally comments) between blocks, or a blank line
# representing any blank lines between the above types of blocks.
# Text sections are terminated by blank lines or by the start of a function.
# Functions are terminated by a } at the start of a line.
# Multiple contiguous blank lines are squeezed to one newline.
# Trailing whitespace (at the end of a line) is not returned.
# The block is put in global Block.  Every line except the last is followed
# by a newline.  A blank block is thus represented as an empty value of Block.
# The number of lines in the block is returned.  0 is returned at EOF.
# If the block being returned is a comment block, and it was terminated by the
# start of a function (without any intervening whitespace), the line count
# returned is negated.
# Globals used: FPat
function GetBlock(InFile, \
Line,LastBlank,FirstLine,IsBlock,Whitespace,NumLines,Term,Ind) {
    if (Ind = Pop(_PushedBlocks)) {
	 Block = _PushedBlocks[Ind]
	 Ind = Pop(_BlockLines)
	 return _BlockLines[Ind]
    }
    Block = ""
    LastBlank = NumLines = Term = 0
    FirstLine = 1
    while ((Line = ReadLine(InFile)) != "\n") {	# Read until EOF or error
	if (!Test)
	    sub("[ \t]+$","",Line)	# Discard trailing whitespace on line
	if (Line == "") {
	    if (!Test && LastBlank)	# Discard 2nd & later blank lines
		continue
	    else
		LastBlank = 1
	}
	else
	    LastBlank = 0
	if (FirstLine) {
	    # Determine if this block is whitespace, or is inside or outside
	    # of a function block
	    if (Line == "")
		Whitespace = 1
	    else
		IsBlock = Line ~ FPat
	    FirstLine = 0
	}
	else {	# After first line
	    if (Whitespace) {
		# All blank lines except the first are discarded, so if we get
		# here, we have found a non-blank line, which means the end
		# of a whitespace block.
		PushLine(Line)
		break
	    }
	    else if (IsBlock) {	#{pair for following close-brace
		if (Line ~ /^}/) {	# Found end of function block
		    Block = Block "\n" Line
		    NumLines++
		    break
		}
	    }
	    else { # Accumulating non-whitespace block outside function block
		if (Line ~ FPat) {	# Found start of function?
		    # Indicate that block was terminated by the start of a 
		    # function.
		    if (Debug)
			print \
			"Found comment block followed by function block." \
			> "/dev/stderr"
		    Term = 1
		    PushLine(Line)
		    break
		}
		else if (Line == "") {
		    PushLine(Line)
		    break
		}
		if (!Quiet && Line !~ /^[ \t]*#/)
		    printf "Warning: at line %d: non-comment outside of "\
		    "block:\n%s\n",NR,Line > "/dev/stderr"
	    }
	}
	if (Block != "")
	    Block = Block "\n" Line
	else
	    Block = Line
	NumLines++
    }
    if (Debug)
	printf "Returning %d-line block.\n",NumLines > "/dev/stderr"
    if (Term)
	return -NumLines
    else
	return NumLines
}

# Return the next line read from InFile (without newline).
# A single newline is returned at EOF or on error.
function ReadLine(InFile,  Line,Ind) {
    if (Ind = Pop(_PushedLines))
	return _PushedLines[Ind]
    else {
	if ((getline Line < InFile) != 1)
	    return "\n"
	else {
	    if (Debug)
		printf "Returning line: %s\n",Line > "/dev/stderr"
	    return Line
	}
    }
}

# Push a line back onto the input.
# Uses global stack _PushedLines[].
function PushLine(Line) {
    Push(_PushedLines,Line)
}

# Push a block back onto the input.
# Uses global stack _PushedBlocks[] (block text) and _BlockLines[] (number
# of lines in the block).
function PushBlock(Lines,Block) {
    Push(_PushedBlocks,Block)
    Push(_BlockLines,Lines)
}

# Push element Elem onto stack Stack
# Pushed data is saved in Stack[] starting at index 1.
# The stack pointer is stored at index "ptr"; it points to top of the
# stack (the last element used).
function Push(Stack,Elem) {
    Stack[++Stack["ptr"]] = Elem
    if (Debug)
	printf "Pushed element %d: %s\n",Stack["ptr"],
	Stack[Stack["ptr"]] > "/dev/stderr"
}

# Pops the top element off of the stack and returns the index of it in Stack.
# If the stack is empty, returns 0.
# NOTE: The data stored at a particular position on the stack is lost when
# either a value is pushed onto its position or the NEXT value is popped.
function Pop(Stack,  Pointer) {
    if ((Pointer = Stack["ptr"]+0) > 0) {
	# If there was data in the last position, delete it.
	delete Stack[Pointer+1]
	Stack["ptr"]--
    }
    return Pointer
}

### Begin-lib ProcArgs
#
# The current version of this library can be found by searching
# http://www.armory.com/~ftp/
#
# @(#) ProcArgs 1.26 2010-05-02
# 1992-02-29 john h. dubois iii (john@armory.com)
# 1993-07-18 Added "#" arg type
# 1993-09-26 Do not count h option against MinArgs
# 1994-01-01 Stop scanning at first non-option arg.  Added ">" option type.
#            Removed meaning of "+" or "-" by itself.
# 1994-03-08 Added & option and *()< option types.
# 1994-04-02 Added NoRCopt to Opts()
# 1994-06-11 Mark numeric variables as such.
# 1994-07-08 Opts(): Do not require any args if h option is given.
# 1995-01-22 Record options given more than once.  Record option num in argv.
# 1995-06-08 Added ExclusiveOptions().
# 1996-01-20 Let rcfiles be a colon-separated list of filenames.
#            Expand $VARNAME at the start of its filenames.
#            Let varname=0 and [-+]option- turn off an option.
# 1996-05-05 Changed meaning of 7th arg to Opts; now can specify exactly how
#            many of the vars should be searched for in the environment.
#            Check for duplicate rcfiles.
# 1996-05-13 Return more specific error values.  Added AllowUnrecOpt.
# 1996-05-23 Check type given for & option
# 1996-06-15 Re-port to awk
# 1996-10-01 Moved file-reading code into ReadConfigFile(), so that it can be
#            used by other functions.
# 1996-10-15 Added OptIntroChars
# 1996-11-01 Added exOpts arg to Opts()
# 1996-11-16 Added ; type
# 1996-12-08 Added Opt2Set() & Opt2Sets()
# 1997-02-22 Remove packed elements.
# 1997-02-28 Make sequence # for rcfiles & environ be "f" and "e".
#            Added OptsGiven().
# 1997-05-26 Added mangleHelp().
# 1997-08-20 Added end-of-line escape char processing to ReadConfigFile()
# 1997-12-21 Improved mangleHelp()
# 1998-04-19 1.2 Moved default file reading code into ReadLogicalLines[].
#            Added quote processing.
# 1999-02-01 1.2.1 Added Opt2Arr()
# 1999-03-25 1.2.2 Removed compress argument to ProcArgs.
#            Opts() now compresses ARGV.
# 1999-05-03 1.2.3 Declare Lines[] in InitOpts()
# 1999-05-05 1.2.4 Bugfix in option deletion
# 2000-01-19 1.2.5 If -x is given, always print value assignments.
# 2000-07-23 1.2.6 Fixed return value of Opt2Arr()
# 2000-10-15 1.2.7 Fix test for ) value
# 2001-04-05 1.2.8 Improved mangleHelp(). ProcArgs sets global _optIntroChar.
# 2001-06-05 1.3 Added Sep option to Opt2Arr().  Set (optname,1).
#            Added addPseudoOpt(), prioOpt(), elideOpts().
#            Made OptsGiven() return a number rather than just true/false
#            and added Results[] parameter.
#            Allow unrecognized options only if they are the first option
#            in an option string.
# 2001-06-13 1.3.1 Minor tweaks to reduce the number of complaints from
#            gawk --lint
# 2001-10-26 1.4 Separated recording of sequence number from recording of data
#            source.  Allow multiple instances of options to be set in a
#            config file.  Record file for each option instance.
#            Added "a" and "p" source types.
# 2002-02-26 1.4.1 Fixed return value of Opt2Set()
# 2002-06-11 1.4.2 Global var fix
# 2002-11-23 1.4.3 Convert \- to - in mangleHelp().
# 2003-04-05 1.4.4 Fixed some global vars to be local.
#            Fixed extra newline added by mangleHelp().
# 2003-05-13 1.5 Added Pat parameter to varValOpt()
# 2003-06-06 1.6 Changed the way multiple instance of Boolean options are dealt
#            with.
# 2003-09-30 1.7 Renamed ProcArgs to _procArgv and changed the way it processes
#            it option-list, as the first step towards a new
#            option-specification syntax.
# 2003-10-07 1.8 Added errVar parm to varValOpt()
# 2004-12-09 1.9 Added Prefix parm to ReadConfigFile()
# 2004-12-20 1.10 Preserve empty lines in quoted sections in ReadLogicalLine().
#            Improved performance of ReadLogicalLine().
# 2004-12-27 1.11 Added Order[] parameter to ReadConfigFile().
#            Added ReturnAll parameter to ReadLogicalLine(),
#            ReadLogicalLines(), and ReadConfigFile().
#            Added WriteConfigFile().
# 2005-06-23 1.12 Removed Lines[] from ReadConfigFile(); added line-num and
#            count info to Values[]
# 2005-10-06 1.12.2 In WriteConfigFile(), skip instances that have been removed
#            from Values[]
# 2005-12-23 1.13 Added DependentOptions()
# 2006-03-13 1.14 Correction to use of Prefix in ReadConfigFile()
# 2006-03-14 1.15 Added Opt2CompSets() and MatchOpt()
# 2006-05-18 1.16 Added OptSel2CompSets(), multiMatchOpt()
# 2006-06-02 1.17 Added Sep parm to Opt2Sets() and Opt2CompSets()
#            Made OptSel2CompSets() not require names in validVars[]
# 2006-08-16 1.18 Fixed & option.
# 2006-11-02 1.19 Added optOrder()
# 2007-11-13 1.19.1 Fixed error in naming of config file in which an error
#            occurred
# 2007-11-14 1.20 Separated expandPathPrefix() from InitOpts() & enhanced it.
# 2007-11-28 1.21 Avoid creating indexes in values[] in multiMatchOpt().
#            Added nullValOK, prefixPat, and varSepPat params to varValOpt().
#            Extended MatchOpt() and multiMatchOpt() to allow test for variable
#            existence.
# 2008-09-08 1.22 Added configFileOpt to Opts().
#            Let numeric values include exponent in the usual form.
# 2009-05-02 1.23 Added Pat param to OptSel2CompSets().
# 2009-07-06 1.23.1 Fixed bug in processing of return value from
#            ReadLogicalLines()
# 2009-11-14 1.24 Added patOrFixed to OptSel2CompSets(); enhanced MatchOpt() to
#            use the match operator type.
# 2010-02-14 1.24.1 Modified Opt2CompSets() to produce output compatible with
#            the enhanced MatchOpt()
# 2010-04-16 1.24.2 On read error, get value of ERRNO before closing file.
#            Corrected ReadConfigFile() to match its documentation:
#            store a null value in Value[] for flags.
# 2010-04-27 1.25 Make OptSel2CompSets() pass varSepPat to varValOpt().
# 2010-05-02 1.26 Replace nullValOK with multiple-meaning noAssignOp.
#            Added noAssignVar to OptSel2CompSets()
#            Let varValOpt(errVar) include a trailing separator string.

# todo: Let gnu-style options (--varname, --varname=value) be given, where
# todo: varname is the variable name as used by Opts().
# todo: Make --help equivalent to -h and implement --version as universal
# todo: option, for help2man.
# todo: Need some way of unsetting options that take values (not just setting
#       them to a null value), so cmd line opts can unset rcfile assignments.
#       Let a value of "-" unset numeric options, and a null string unset
#       strings that are not allowed to be 0 length.
#       For strings that are allowed to b 0 length, maybe +opt (but should be
#       compatible with gnu).
# todo: If -x is given, also print assignments to options that do not have
#       variables.  Maybe make option letter be default variable name.
# todo: Use exclusive-option info to prevent setting of options found in
#       lower-priority sources that are incompatible with options found in
#       higher-priority sources.
# todo: Ignore case in variable names.
# todo: New option/value-name syntax, e.g. "x>debug|r;reports|c=autocase"
#       (varname always required, = specifying a flag) - other flags to
#       indicate whether option should be allowed on
#	cmd-line/rcfile/environment/cgi-environment
# todo: Add some syntax for indicating that a single instance of an option may
#       include multiple values, and the pattern/chars that will separate them.
# todo: If no x option specified, use it to turn on debugging and set global
#       Debug flag.  If no n option, use it to prevent reading of rcfile.
# todo: Opts() should really just set ARGC directly.
# todo: Ability to extract named options from the environment as QUERY_varname
#       instead of just varname, to make use of awk programs directly as cgi
#       programs easier.
# todo: Let integer options take values in alternate bases.
# todo: Add a character type, understanding escape sequences, var. integer
#       value specs, a "path" type that expands leading ~ and $varname, etc.
# todo: Make -? a synonym for -h.

# _procArgv(): Process arguments given on the command line.
# This function retrieves options given as initial arguments on the command
# line.
#
# Strings in argv[] which begin with "-" or "+" are taken to be
# strings of options, except that a string which consists solely of "-"
# or "+" is taken to be a non-option string; like other non-option strings,
# it stops the scanning of argv and is left in argv[].
# An argument of "--" or "++" also stops the scanning of argv[] but is removed.
# If an option takes an argument, the argument may either immediately
# follow it or be given separately.
# "-" and "+" options are treated the same.  "+" is allowed because most awks
# take any -options to be arguments to themselves.  gawk 2.15 was enhanced to
# stop scanning when it encounters an unrecognized option, though until 2.15.5
# this feature had a flaw that caused problems in some cases.  See the
# OptIntroChars parameter to explicitly set the option-introduction characters.
# Note that POSIX 1003.1-2001 generally prohibits introducing options with "+".
#
# Option processing will stop with the first unrecognized option, just as
# though -- or ++ was given except that the unrecognized option will not be
# removed from ARGV[].  Normally an error value is returned in this case,
# but see the description of AllowUnrecOpt.

# Input variables:
# argv[] contains the arguments.
# argc is the number of elements in argv[].
#
# OptParms[] describes the legal options and their type.
# See _parseGetoptsOptList() for further description.
#
# If AllowUnrecOpt is true, it is not an error for an unrecognized option to
# be found as long as it is the first option in an option string; instead
# it simply causes option processing to stop without an error as though the
# argument that contained the unrecognized option did not begin with an option
# introduction character.
#
# If OptIntroChars is not a null string, it is the set of characters that
# indicate that an argument is an option string if the string begins with one
# of the characters.  The default is "-+".  A string consisting solely of two
# of the same option-introduction characters stops the scanning of argv[].

# Output variables:
# Options and their arguments are deleted from argv[].
# Note that this means that there may be gaps left in the indices of argv[].

# All option date is stored in Options[], as follows:
#
# The first time a particular option is given, Options[option-name] and
# Options[option-name,1] are set to the value of the argument given
# for it, and Options[option-name,"count"] is (initially) set to 1.
# If it is given more than once, for the second and later instances
# Options[option-name,"count"] is incremented and the value of the argument
# given for it is assigned to Options[option-name,instance] where instance is 2
# for the second occurrence of the option, etc.
# In other words, the first time an option with a value is encountered, the
# value is assigned both to an index consisting only of its name and to an
# index consisting of its name and instance number; for any further
# occurrences of the option, the value is assigned only to the index that
# includes the instance number.  All values given for an option are stored.
# If a program uses multiple instance of an option but should only pay
# attention to instances that occur in the first venue in which an option is
# found, they must do so explicitly.

# The value of a Boolean (flag) option is 1 if it is given normally, and 0 if
# it is turned off by being followed with a "-". In other words, if -x is
# given, the "x" option gets a value of 1; if -x- is given, the "x" option gets
# a value of 0.  Other than this, the only difference between Boolean options
# and value options is that Options[option-name] is left unset if the first
# instance of an option is one that is turned off.  This allows an option to be
# checked for with the test "if (option-name in Options)", while also allowing
# an option that is turned on in a config file to be turned off on the command
# line.  The values for Boolean options that include instance numbers,
# including that for instance 1, are given the 1 or 0 value.  To explicitly
# check for whether the first instance of an option was turned off (as opposed
# to the option not being given at all), check for instance 1 of it.  This can
# be useful for Boolean options that are turned on by default.

# Options[option-name,"source",instance] is set to the source of data for each
# instance of the option (the venue in which that instance of the option was
# encountered).  The possible values are "f" (config file), "e" (environment),
# "a" (argv[]), and "p" (pseudo-opt).
# If an option is set from a config file, Options[option-name,"file",instance]
# is set to the filename.

# The sequence number for each option is stored in
# Options[option-name,"num",instance], where instance is 1 for the first
# occurrence of the option, etc.  The sequence number tells the position in a
# given venue (source) in which the option occurred; it starts at 1 and is
# incremented for each option found, both those that have a value and those
# that do not.  It starts over at 1 when the next venue is processed.

# Return value:
# The number of arguments left in argv is returned (should always be at least
# 1).
# If an error occurs, the global string _procArgv_err is set to an error
# message and a negative value is returned.
#
# Globals:
# _procArgv_err (see above).
# The last option-introduction character processed is stored in the global
# _optIntroChar for use by error messages.
# Current error values:
# -1: option that required an argument did not get it.
# -2: argument of incorrect type supplied for an option.
# -3: unrecognized (invalid) option.
function _procArgv(argc, argv, OptParms, Options, AllowUnrecOpt, OptIntroChars,

	ArgNum, ArgsLeft, Arg, ArgLen, ArgInd, Option, NumOpt, Value, HadValue,
	NeedNextOpt, GotValue, OptionNum, c, OptTerm, OptIntroCharSet)
{
# ArgNum is the index of the argument being processed.
# ArgsLeft is the number of arguments left in argv.
# Arg is the argument being processed.
# ArgLen is the length of the argument being processed.
# ArgInd is the position of the character in Arg being processed.
# Option is the character in Arg being processed.
# NumOpt is true if a numeric option may be given.
# Value is the value given with an option.
    ArgsLeft = argc
    NumOpt = ("&", "type") in OptParms
    OptionNum = 0
    # Build option specifier sets
    if (OptIntroChars == "")
	OptIntroChars = "-+"
    while (OptIntroChars != "") {
	c = substr(OptIntroChars,1,1)
	OptIntroChars = substr(OptIntroChars,2)
	OptIntroCharSet[c]	# Option introduction character set
	OptTerm[c c]		# Option terminator string set
    }
    for (ArgNum = 1; ArgNum < argc; ArgNum++) {
	Arg = argv[ArgNum]
	if (length(Arg) < 2 || \
	!((_optIntroChar = substr(Arg,1,1)) in OptIntroCharSet))
	    break	# Not an option; quit
	if (Arg in OptTerm) {	# Option list explicitly terminated
	    delete argv[ArgNum]	# Discard Option List Terminator
	    ArgsLeft--
	    break
	}
	ArgLen = length(Arg)
	# For each character in this string after the option intro character...
	for (ArgInd = 2; ArgInd <= ArgLen; ArgInd++) {
	    Option = substr(Arg,ArgInd,1)
	    if (NumOpt && Option ~ /[-+.0-9]/) {
		# If this option is a numeric option, make its flag be &
		Option = "&"
		# Prefix Arg with a char so that ArgInd will point to the
		# first char of the numeric option.
		Arg = "&" Arg
		ArgLen++
	    }
	    # Get type of option.  Disallow & as literal flag.
	    else if (!((Option,"type") in OptParms) || Option == "&") {
		# Unrecognized options may be allowed, but only if they
		# occur at the start of an option string, because there is
		# no means to pass the offset of the problematic option back.
		if (AllowUnrecOpt && ArgInd == 2)
		    return ArgsLeft
		else {
		    _procArgv_err = "Invalid option: " _optIntroChar Option
		    return -3
		}
	    }

	    # Find what the value of the option will be if it takes one.
	    # NeedNextOpt is true if the option specifier is the last char of
	    # this arg, which means that if the option requires a value it is
	    # the following arg.
	    if (NeedNextOpt = (ArgInd >= ArgLen)) {
		# Value is the following arg
		if (GotValue = ((ArgNum + 1) < argc))
		    Value = argv[ArgNum+1]
	    }
	    else {	# Value is included with option
		Value = substr(Arg,ArgInd + 1)
		GotValue = 1
	    }

	    # _assignVal returns: negative value on error,
	    # 0 if option did not require an argument,
	    # 1 if it did & used the whole arg,
	    # 2 if it required just one char of the arg.
	    if (HadValue = _assignVal(Option, Value, Options, OptParms,
		    GotValue, "", ++OptionNum, "a", "", !NeedNextOpt,
		    _optIntroChar)) {
		if (HadValue < 0)	# error occurred
		    return HadValue
		if (HadValue == 2)
		    ArgInd++	# Account for the single-char value we used.
		else {
		    if (NeedNextOpt) {
			# Last option spec was the last char of its arg.
			# Since this option required a value,
			# it took the following arg as value.
			# Discard Option; code we break to will discard value
			delete argv[ArgNum++]
			ArgsLeft--
		    }
		    break	# This option has been used up
		}
	    }
	}
	# Do not delete arg until after processing of it, so that if it is not
	# recognized it can be left in ARGV[].
	delete argv[ArgNum]	# Discard Option or Option Value
	ArgsLeft--
    }
    return ArgsLeft
}

# _parseGetoptsOptList(): Parse a getopts-style option list.
# The option list is a string which contains all of the possible command line
# options.
# A character followed by certain characters indicates that the option takes
# an argument, with type as follows:
# :	String argument
# ;	Non-empty string argument
# *	Numeric argument (may include decimal point and fraction)
# (	Non-negative numeric argument
# )	Positive numeric argument
# #	Integer argument
# <	Non-negative integer argument
# >	Positive integer argument
# The only difference the type of argument makes is in the runtime argument
# error checking that is done.
#
# The & option is a special case used to get numeric options without the
# user having to give an option character.  It is shorthand for [-+.0-9].
# If & is included in optlist and an option string that begins with one of
# these characters is seen, the value given to "&" will include the first
# char of the option.  & must be followed by a type character other than ":"
# or ";".
# Note that if e.g. &> is given, an option of -.5 will produce an error.
# Also note that POSIX 1003.1-2001 generally prohibits options consisting of
# digit-strings.

# In addition to letters and numerals, @%_=,./ are reasonable characters to
# use as options.

# Input variables:
#
# OptList is the getopts-style option list.
#
# Output variables:
#
# For each option specified, the type of the option is stored in OptParms[] by
# assigning values to various indexes of the form OptParms[option-letter,parm]
# as follows:
#
#  Type  Indexes set
# -----  ----------------------------
#  flag  "type" = "flag"
#     :	 "type" = "string", "minlen" = 0
#     ;	 "type" = "string", "minlen" = 1
#     *	 "type" = "number"
#     (	 "type" = "number", "ge" = 0
#     )	 "type" = "number", "gt" = 0
#     #	 "type" = "integer"
#     <	 "type" = "integer", "ge" = 0
#     >	 "type" = "integer", "gt" = 0
#
# Return value:
# On success, a null string.
# On failure, an error description.
function _parseGetoptsOptList(OptList, OptParms,

	i, len, optChar, typeChar, type)
{
    len = length(OptList)
    for (i = 1; i <= len; i++) {
	optChar = substr(OptList, i, 1)
	if (index(":;*()#<>-+|", optChar))
	    return "Disallowed option character: " optChar
	else {
	    typeChar = substr(OptList, i+1, 1)
	    if (typeChar == "")	# end of string
		type = "flag"
	    else if (index(":;", typeChar)) {
		type = "string"
		if (typeChar == ":")
		    OptParms[optChar, "minlen"] = 0
		else
		    OptParms[optChar, "minlen"] = 1
	    }
	    else if (index("*()", typeChar))
		type = "number"
	    else if (index("#<>", typeChar))
		type = "integer"
	    else
		type = "flag"
	    if (optChar == "&" && type != "integer" && type != "number")
		return "Option & must have integer or number type"
	    if (index("(<", typeChar))
		OptParms[optChar, "ge"] = 0
	    else if (index(")>", typeChar))
		OptParms[optChar, "gt"] = 0
	    OptParms[optChar, "type"] = type
	    i += type != "flag"
	}
    }
    return ""
}

# _parseVarDesc(): Parse a variable description.
# Variable descriptions have this format:
# option-character,option-name,option-type[,extra-parameter-name=value,...]
# option-character is a single character that may be used to give the option
#     on the command line either in traditional POSIX syntax
#     (-option-letter[value]) or in GNU-style syntax (--option-letter[=value])
# option-name is a name that may be used to give the option in any venue:
#    on the command line as a GNU-style option, in a config file, or (if
#    allowed) in the environment.
# At least one of option-character and option-name must be given.
#     If a single-character option-name is given, it must not be the same as
#     the option-character for any other option.
# option-type is the type of the option.  It is required.  The types are:
#     string - any string
#     number - any number representable in a double
#     integer - any whole number representable in an int
# Any parameters given after the third have the form "name=value".
#     Only specific names are allowed, and some names are only allowed for
#     certain types.
#     The parameters that may be specified are:
#     ge: A value that a number/integer must be greater than or equal to
#     gt: A value that a number/integer must be greater than
#     minval: A mininum length for strings
#     sources: A string of characters represending the venues in which the
#         option-name may be given.  If not given, the option may be given
#         either in a config file (if any are specified) or on the command
#         line.  The characters are:
#         f: The option may be specified in a config file
#         a: The option may be given as an argument on the command line
#         e: The option may be given in the environment
#
# Input variables:
# varDesc is the variable description.
#
# Output variables:
# The option parameters are stored in OptParms[].

# For each option specified, the type of the option is stored in OptParms[] by
# assigning values to various indexes of the form OptParms[option-letter,parm]
# as follows:
#
# !!! Fill this in
#
# Return value:
# On success, a null string.
# On failure, a string describing the problem.
function _parseVarDesc(varDesc, OptParms,

	parms, parmFields, numFields, char, name, type, pos, parmName, val,
	source, i, len, optNum, fieldNum)
{
    numFields = split(varDesc, parmFields, ",")
    char = parmFields[1]
    name = parmFields[2] 
    type = parmFields[3]
    if (char == "" && name == "" || type == "")
	return "Invalid option description; "\
		"must include a type and a character or name"
    if (type != "string" && type != "number" && type != "integer")
	return "Invalid type (must be string, number, or integer): " type
    parms["type"] = type

    # Process parameters and check the values assigned to them.
    # The results are stored in parms[] and in the variable "source".
    for (fieldNum = 4; fieldNum <= numFields; fieldNum++) {

	# Split parameter into name and value
	parmName = parmFields[fieldNum]
	pos = index(parmName, "=")
	if (!pos)
	    return "No value assigned to parameter \"" parmName "\""
	val = substr(parmName, pos+1)
	parmName = substr(parmName, 1, pos-1)

	if (parmName == "ge" || parmName == "gt") {
	    if (type != "integer" && type != "number")
		return "Parameter \"" parmName \
			"\" cannot be applied to type " type
	    if (val !~ /^[-+]?([[:digit:]]+\.?|[[:digit:]]*\.[[:digit:]]+)([eE][-+][[:digit:]]+)?$/)
		return "Parameter \"" parmName "\" must have numeric value"
	    parms[parmName] = val+0
	}
	else if (parmName == "minlen") {
	    if (type != "string")
		return "Parameter \"" parmName \
			"\" cannot be applied to type " type
	    if (val !~ /^\+?[0-9]+$/)
		return "Parameter \"" parmName \
			"\" must have non-negative integer value"
	    parms[parmName] = val+0
	}
	else if (parmName == "sources") {
	    if (val !~ /^[fae]+$/)
		return "Parameter \"" parmName "\" must have a value "\
			"consisting of one or more of the letters: fae"
	    source = val
	}
	else
	    return "Unknown parameter name \"" parmName "\""
    }

    optNum = ++OptParms["numopts"]
    if (char != "") {
	if (index(":;*()#<>-+|", char))
	    return "Disallowed option character: " char
	OptParms[char,"arg"]
	_storeParms(char, parms, OptParms)
	OptParms["options", optNum, "char"] = char
    }
    if (name != "") {
	if (name !~ /^[[:alnum:]][-_[:alnum:]]*$/)
	    return "Invalid option name: " name
	# Named parameters may by default be given in a file or on the command
	# line.
	if (source == "")
	    source = "fa"
	len = length(source)
	for (i = 1; i <= len; i++)
	    OptParms[char,substr(source,i,1)]
	_storeParms(name, parms, OptParms)
	OptParms["options", optNum, "name"] = name
    }
    if (char != "" && name != "") {
	OptParms[char,"alt"] = name
	OptParms[name,"alt"] = char
    }
    return ""
}

function _storeParms(name, parms, out,

	parm)
{
    for (parm in parms)
	out[name, parm] = parms[parm]
}

# _assignVal(): Store an option.
# Assignment to values in Options[] occurs only in this function.
#
# Input variables:
# Option: Option specifier character.
# Value: Value to be assigned to option, if it takes a value.
# OptParms[]: Option descriptions.  See _parseGetoptsOptList().
# GotValue: Whether any value is available to be assigned to this option.
# Name: Name of option being processed.
# OptionNum: Sequence number of this option (starting with 1) for the source it
#     comes from.  For example, each option found on the command line should
#     get a successive integer, as should each option found in a given config
#     file.
# SingleOpt: true if the value (if any) that is available for this option was
#     given as part of the same command line arg as the option.  Used only for
#     options from the command line.
# specGiven is the option specifier character used, if any (e.g. - or +),
#     for use in error messages.
#
# Output variables:
# Options[]: Options array to return values in.
#
# Global variables:
# On failure, a description of the error is stored in _procArgv_err
#
# Return value:
# On success:
# 0 if option did not require an argument
# 1 if option did require an argument and used the entire argument
# 2 if option required just one character of the argument
# On failure: A negative value.
# Current error values:
# -1: Option that required an argument did not get it.
# -2: Value of incorrect type supplied for option.
# -3: Assertion failure
function _assignVal(Option, Value, Options, OptParms, GotValue, Name,
	OptionNum, Source, File, SingleOpt, specGiven,

	Instance, UsedValue, Err, numericType, type)
{
    if (!((Option,"type") in OptParms)) {
	# This should never happen
	_procArgv_err = "_assignVal(): No type for option \"" Option "\"!"
	return -3
    }
    type = OptParms[Option, "type"]
    numericType = type == "integer" || type == "number"
    # If argument is of any of the types that takes a value...
    if (type != "flag") {
	if (!GotValue) {
	    if (Name != "")
		_procArgv_err = "Variable requires a value -- " Name
	    else
		_procArgv_err = "option requires an argument -- " Option
	    return -1
	}
	if ((Err = _checkValue(OptParms,Value,Option,Name,specGiven)) != "") {
	    _procArgv_err = Err
	    return -2
	}
	# Mark this as a numeric variable; will be propagated to Options[] val.
	if (numericType)
	    Value += 0
	UsedValue = 1
    }
    else {	# Option is a flag
	if (Source != "a" && Value != "") {
	    # If this is an environ or rcfile assignment & it was given a value
	    # despite being a flag...
	    Value = !(Value == "0" || Value == "-")
	    UsedValue = 1
	}
	else if (OptionNum && SingleOpt && substr(Value,1,1) == "-") {
	    # If this is a command line flag and has a - following it in the
	    # same arg, the flag is being turned off.
	    Value = 0
	    UsedValue = 2
	}
	else {
	    # If this is a flag assignment w/o a value, it is being turned on.
	    Value = 1
	    UsedValue = 0
	}
    }
    if ((Instance = ++Options[Option,"count"]) == 1 &&
	    (type != "flag" || Value))
	Options[Option] = Value
    Options[Option,Instance] = Value

    Options[Option,"num",Instance] = OptionNum
    Options[Option,"source",Instance] = Source
    if (Source == "f")
	Options[Option,"file",Instance] = File
    return UsedValue
}

# _checkValue is used to check that an appropriate value is assigned to an
# option that takes a value.
# OptChar is the option letter
# Value is the value being assigned
# Name is the var name of the option, if any
# OptParms[] describes the options
# specGiven is the option specifier character use, if any (e.g. - or +),
#     for use in error messages.
# Return value:
# Null on success, error string on error
function _checkValue(OptParms, Value, OptChar, Name, specGiven,

	Err, ErrStr, V, type, minlen, ge, gt)
{
    type = OptParms[OptChar, "type"]
    if (type == "string") {
	if (length(Value) < (minlen = OptParms[OptChar,"minlen"]))
	    if (minlen == 1)
		Err = "must be a non-empty string"
	    else
		Err = "must be a string of length at least " minlen
    }
    else if (type != "integer" && type != "number")
	# This should never happen
	return "_checkValue(): Invalid type \"" type "\" for option \"" \
		OptChar "\"!"
    # All remaining types are numeric.
    # A number begins with optional + or -, and is followed by a string of
    # digits or a decimal with digits before it, after it, or both
    else if (Value !~ /^[-+]?([[:digit:]]+\.?|[[:digit:]]*\.[[:digit:]]+)([eE][-+][[:digit:]]+)?$/)
	Err = "must be a number"
    else if (type == "integer" && index(Value,"."))
	Err = "may not include a fraction"
    else {
	V = Value + 0
	if ((OptChar, "gt") in OptParms)
	    gt = OptParms[OptChar, "gt"]
	else if ((OptChar, "ge") in OptParms)
	    ge = OptParms[OptChar, "ge"]
	if (V < 0 && ge != "" && ge == 0)	# >= 0
	    Err = "may not be negative"
	else if (V <= 0 && gt != "" && gt == 0)	# > 0
	    Err = "must be a positive number"
	else if (ge != "" && V < ge)
	    Err = "must be a number >= " ge
	else if (gt != "" && V <= gt)
	    Err = "must be a number > " gt
    }
    if (Err != "") {
	ErrStr = "Bad value \"" Value "\".  Value assigned to "
	if (Name != "")
	    return ErrStr "variable " substr(Name,1,1) " " Err
	else {
	    if (OptChar == "&")
		OptChar = Value
	    return ErrStr "option " specGiven substr(OptChar,1,1) " " Err
	}
    }
    else
	return ""
}

# Note: only the above functions are needed by _procArgv.
# The rest of these functions call _procArgv() and also do other
# option-processing stuff.

# Opts: Process command line arguments.
# Opts processes command line arguments using _procArgv()
# and checks for errors.  If an error occurs, a message is printed
# and the program is exited.
#
# Input variables:
# Name is the name of the program, for error messages.
# Usage is a usage message, for error messages.
# OptList the option description string, as used by _procArgv().
# MinArgs is the minimum number of non-option arguments that this
# program should have, non including ARGV[0] and +h.
# If the program does not require any non-option arguments,
# MinArgs should be omitted or given as 0.
# rcFiles, if given, is a colon-seprated list of filenames to read for
# variable initialization.  If a filename begins with ~/, the ~ is replaced
# by the value of the environment variable HOME.  If a filename begins with
# $, the part from the character after the $ up until (but not including)
# the first nonalphanumeric character will be searched for in the
# environment; if found its value will be substituted, if not the filename will
# be discarded.
# rcfiles are read in the order given.
# Values given in them will not override values given on the command line,
# and values given in later files will not override those set in earlier
# files, because _assignVal() will store each with a different instance index.
# The first instance of each variable, either on the command line or in an
# rcfile, will be stored with no instance index, and this is the value
# normally used by programs that call this function.
# VarNames is a comma-separated list of variable names to map to options,
# in the same order as the options are given in OptList.
# If EnvSearch is given and nonzero, the first EnvSearch variables will also be
# searched for in the environment.  If set to -1, all values will be searched
# for in the environment.  Values given in the environment will override
# those given in the rcfiles but not those given on the command line.
# NoRCopt, if given, is an additional letter option that if given on the
# command line prevents the rcfiles and environment from being read.
# configFileOpt can be used to specify an option that sets the configuration
# file list.  If the option letter is preceded by a ":" and the option is
# given, the named configuration file is required to exist.
# See _procArgv() for a description of AllowUnRecOpt and optIntroChars, and
# ExclusiveOptions() for a description of exOpts.
# Special options:
# If x is made an option and is given, some debugging info is output.
# h is assumed to be the help option.

# Global variables:
# The command line arguments are taken from ARGV[].
# The arguments that are option specifiers and values are removed from
# ARGV[], leaving only ARGV[0] and the non-option arguments, with the
# non-option arguments moved down so that they start at index 1.
# The number of elements in ARGV[] should be in ARGC.
# After processing, ARGC is set to the number of elements left in ARGV[].
# The option values are put in Options[].
# On error, Err is set to a positive integer value so it can be checked for in
# an END block.
# _procArgv_err may be set by this function, and is also used by it when it is
# set by other functions (InitOpts()).
# Return value: The number of elements left in ARGV is returned.
# todo: Maybe make variable names case-independent?
function Opts(Name, Usage, OptList, MinArgs, rcFiles, VarNames, EnvSearch,
	NoRCopt, AllowUnrecOpt, optIntroChars, exOpts, configFileOpt,

	Var, Var2Char, VarInfo, ArgsLeft, e, Debug, OptParms, errStr,
	configFileMustExist)
{
    if (MinArgs == "")
	MinArgs = 0
    if (substr(configFileOpt, 1, 1) == ":") {
	configFileMustExist = 1
	configFileOpt = substr(configFileOpt, 2)
    }
    if ((errStr = _parseGetoptsOptList(OptList NoRCopt configFileOpt (configFileOpt == "" ? "" : ";"), OptParms)) != "") {
	printf "%s: Option list specification error: %s.\n",
		Name, errStr > "/dev/stderr"
	Err = 1
	exit 1
    }
    # Process command line arguments
    ArgsLeft = _procArgv(ARGC, ARGV, OptParms, Options, AllowUnrecOpt,
			optIntroChars)
    if ("x" in Options) {
	Debug = Options["x"]
	if (Debug == "")
	    Debug = 1
    }
    else
	Debug = 0
    if (ArgsLeft < (MinArgs+1) && !("h" in Options)) {
	if (ArgsLeft >= 0) {
	    _procArgv_err = "Not enough arguments"
	    Err = 4
	}
	else
	    Err = -ArgsLeft
	print mangleHelp(sprintf("%s: %s.\nUse -h for help.\n%s",
	Name,_procArgv_err,Usage)," \t\n[") > "/dev/stderr"
	exit 2
    }
    if (ArgsLeft > 1)
	paPackArr(ARGV,ArgsLeft-1,1)

    split("",Var2Char);	# Let awk know this is an array
    split("",VarInfo);	# Let awk know this is an array
    mkVarMap(OptList,VarNames,EnvSearch,Var2Char,VarInfo)

    # Process environment & rcfiles
    if (configFileOpt in Options)
	rcFiles = Options[configFileOpt]
    if (rcFiles != "" && (NoRCopt == "" || !(NoRCopt in Options)) &&
    (e = InitOpts(rcFiles,Options,Var2Char,OptParms,VarInfo,Debug,
	    configFileMustExist)) < 0) {
	print Name ": " _procArgv_err ".\nUse -h for help." > "/dev/stderr"
	Err = -e
	exit 2
    }
    if (Debug)
	for (Var in Var2Char)
	    if (Var2Char[Var] in Options)
		printf "(%s) %s=%s\n",
		Var2Char[Var],Var,Options[Var2Char[Var]] > "/dev/stderr"
	    else
		printf "(%s) %s not set\n",Var2Char[Var],Var > "/dev/stderr"
    if ((exOpts != "") &&
	    ((_procArgv_err = ExclusiveOptions(exOpts,Options)) != ""))
    {
	printf "%s: Error: %s\n",Name,_procArgv_err > "/dev/stderr"
	Err = 1
	exit 2
    }
    return ArgsLeft
}

# Packs Arr[], which should have integer indices starting at or above n,
# to contiguous integer indices starting with n.
# If n is not given it defaults to 0.
# Num should be the number of elements in Arr.
function paPackArr(Arr, Num, n,

	NewInd, OldInd)
{
    NewInd = OldInd = n+0
    for (; Num; Num--) {
	while (!(OldInd in Arr))
	    OldInd++
	if (NewInd != OldInd) {
	    Arr[NewInd] = Arr[OldInd]
	    delete Arr[OldInd]
	}
	OldInd++
	NewInd++
    }
}

# mangleHelp(): Convert a help message so that options are displayed with
# the appropriate option introduction character.
# If the last option given was introduced with "+" or this is awk and no
# options were given, convert -x options in a help message to +x.
# If whitespace is non-null, it is the set of characters that may precede an
# option indicator to indicate that it is such.
# The default is newline, space, or tab.
# -x options may be escaped so that they are not acted on by preceding them
# with "\".  All instances of \- are converted to -.
# The output will *not* have a trailing newline, even if the input did.
function mangleHelp(message, whitespace,

	i, wChar, elem, j, n)
{
    if (_optIntroChar == "+" || _optIntroChar == "" && ARGV[0] == "awk") {
	if (whitespace == "")
	    whitespace = " \t\n"
	# For each possible whitespace character...
	for (i = 1; (wChar = substr(whitespace,i,1)) != ""; i++) {
	    n = split(message,elem,"\\" wChar "-")
	    message = elem[1]
	    # Replace all -x except -- with +x
	    for (j = 2; j <= n; j++)
		if (substr(elem[j],1,1) == "-")
		    message = message wChar "-" elem[j]
		else
		    message = message wChar "+" elem[j]
	}
    }
    # The \-x -> -x conversion needs to be done regardless of whether the
    # option introduction characters are being converted.
    # gsub is done line at a time rather than on the whole message at once
    # because some awks die when trying to do a gsub on a very long string.
    # Yuck!
    n = split(message,elem,"\n")
    if (elem[n] == "")
	n--
    message = ""
    for (i = 1; i <= n; i++) {
	gsub(/\\-/,"-",elem[i])
	message = message elem[i]
	if (i < n)
	    message = message "\n"
    }
    return message
}

# Remove all of the options in optList from a "Usage:" (not help) message.
function elideOpts(optList, usageMessage,

	i, c, len)
{
    len = length(optList)
    for (i = 1; i <= len; i++) {
	c = substr(optList,i,1)
	# Remove character from flags list
	usageMessage = \
		gensub("(\\[[^<>]*)" c "([^<>]*\\])","\\1\\2",1,usageMessage)
	# Remove option + value description, e.g. [-optname<option-desc>]
	sub("\\[-" c "[^]]*\\] *","",usageMessage)
    }
    # Remove empty flags lists
    gsub(/-?\[-?\] */,"",usageMessage)
    # Remove now-empty lines
    gsub(/\n[ \t]+\n/,"\n",usageMessage)
    return usageMessage
}

# ReadConfigFile(): Read a file containing var/value assignments, in the form
# <variable-name><assignment-char><value>.
# Whitespace (spaces and tabs) around a variable (leading whitespace on the
# line and whitespace between the variable name and the assignment character)
# is stripped.  Lines that do not contain an assignment operator or which
# contain a null variable name are ignored, other than possibly being noted in
# the return value.
# Input variables:
# File is the file to read.
# AssignOp is the assignment string.  The first instance of AssignOp on a line
#     separates the variable name from its value.
# If StripWhite is true, whitespace around the value (whitespace between the
#     assignment char and the value, and whitespace at the end of the logical
#     line) is stripped.
# VarPat is a pattern that variable names must match.
#     Example: "^[[:alpha:]][[:alnum:]]+$"
#     It should ensure that variable names cannot include SUBSEP.
# If FlagsOK is true, variables are allowed to be "set" by being put alone on
#     a line; no assignment operator is needed.  These variables are set in
#     the output array with a null value.  Lines containing nothing but
#     whitespace are still ignored.
# If Debug is true, debugging information is printed.
# Prefix can be used to set a common index prefix for all information stored
#     in the output arrays (see the description of Values[]).
# Comment, Escape, Quote: See ReadLogicalLine().
# ReturnAll: See ReadLogicalLine().  If ReturnAll is used, empty lines are
#     treated as null assignments to the null variable name and comments are
#     treated as assignments to a variable whose name is the comment character,
#     with the value being the entire comment including the comment character
#     (but without any leading space that occurred before the comment
#     character).
# Output variables:
# None of these arrays is initially cleared, so ReadConfigFile() can be used to
# process multiple files in succession as though they were a single file.
# Values[] contains the assignments.  The first time an assignment to a given
#     variable name is encountered, it is stored under two indexes,
#     <variable-name> and <variable-name>,1.  Any further assignments to a
#     given variable are stored under <variable-name>,<instance-number>.
#     Values[<variable-name>,"num"] is set to the number of times a given
#     variable was encountered (the highest index used).
#     Values[<variable-name>,"lnum"] and
#     Values[<variable-name>,<instance-number>,"lnum"] are set to the line
#     number that a given variable assignment occurred on.  A flag set is
#     recorded by giving it an "lnum"-style index only. 
#     All indexes are prefixed with Prefix.
# Counts[<variable-name>] is set to the number of times a given variable was
#     encountered.  Its indexes form the set of all variable names encountered.
#     All indexes are prefixed with Prefix.
# Order[] records the order in which variables are seen.  For each variable
#     name seen, Order[n] is set to that variable name (prefixed with Prefix),
#     where n is an integer progressing from 1 and gives the order in which the
#     variable was first seen relative to other variable names.
#     For each assignment seen, Order["instance",m] is set to
#     [varname SUBSEP instance] (prefixed with Prefix), where m is as for n but
#     counted separately, and instance is the instance number for varname.  The
#     total number of assignments (the last value of m used) is stored in
#     Order["num"]
# Return value:
# If any errors occur, a string consisting of descriptions of the errors
# separated by newlines is returned, with each string preceded by a numeric
# value and a colon.  The following strings may change and new values may be
# added but the currently assigned numeric values will not:
# -1:IO error reading from file
# -2:Bad variable name
# -3:Bad assignment
# -4:Last line of file ended with line escape char or within quoted section
# If no errors occur, the number of physical lines read is returned.
function ReadConfigFile(Values, Counts, File, Comment, AssignOp, Escape, Quote,
	StripWhite, VarPat, FlagsOK, Debug, Prefix, ReturnAll, Order,

	Line, Errs, AssignLen, LineNum, Var, Val, inLines, lineNums, num, Pos,
	instance, i, varNum, instanceNum)
{
    split("",inLines)	# let awk know this is an array
    split("",lineNums)	# let awk know this is an array
    Errs = ""
    AssignLen = length(AssignOp)
    if (VarPat == "")
	VarPat = "."	# null varname not allowed
    num = ReadLogicalLines(File, Comment, Escape, Quote, inLines, lineNums,
	    Debug, ReturnAll)
    if ((num+0) < 0)
	return num
    if (Debug)
	printf "Processing %d lines from configuration file %s\n", num, File > "/dev/stderr"
    for (i = 1; i <= num; i++) {
	Line = inLines[i]
	if (ReturnAll && substr(Line,1,1) == Comment) {
	    Var = "#"
	    Val = Line
	    Pos = 1
	}
	else {
	    Pos = index(Line,AssignOp)
	    if (Pos) {
		Var = substr(Line,1,Pos-1)
		Val = substr(Line,Pos+AssignLen)
		if (StripWhite) {
		    sub("^[ \t]+","",Val)
		    sub("[ \t]+$","",Val)
		}
	    }
	    else {
		Var = Line	# If no value, var is entire line
		Val = ""
	    }
	}
	LineNum = lineNums[i]
	if (!FlagsOK && Val == "") {
	    Errs = Errs \
		    sprintf("\n-3:Bad assignment on line %d of file %s: %s",
		    LineNum,File,Line)
	    continue
	}
	sub("[ \t\n]+$","",Var)	# Remove trailing whitespace from varname
	if (Var !~ VarPat && !(ReturnAll && (Var == "" || Var == Comment))) {
	    Errs = \
	    Errs sprintf("\n-2:Bad variable name on line %d of file %s: %s",
	    LineNum,File,Var)
	    continue
	}
	if ((instance = Counts[Prefix Var] = ++Values[Prefix Var,"num"]) == 1) {
	    Values[Prefix Var,"lnum"] = LineNum
	    Values[Prefix Var] = Val
	    Order[++varNum] = Prefix Var
	}
	Values[Prefix Var,instance,"lnum"] = LineNum
	Order["instance",++instanceNum] = Prefix Var SUBSEP instance
	Values[Prefix Var,instance] = Val
    }
    if (instanceNum)
	Order["num"] = instanceNum
    return (Errs == "") ? LineNum : substr(Errs,2)	# Skip first newline
}

# Write out the contents of a config file as read by ReadConfigFile().
# If ReadConfigFile() was not given a true value for ReturnAll, blank lines
# and comment lines will not be available for writing.
# The effect of reading a file with ReadConfigFile() and then writing it out
# with WriteConfigFile() will be a file that will give the same results when
# read again by ReadConfigFile().
# The raw file contents will reflect various canonicalizations, including:
#     Blank lines will have no contents
#     Comment lines will have no leading whitespace
#     If a quote character is given, quoting will be used instead of escaping
#         for all quoting purposes other than quoting the quote character.
#	  By default, values are quoted if they contain the escape character,
#         the quote character, or newlines.  Use noQuotePattern to expand this
#         to include other whitespace, etc.
# The specific instance number of each variable given in Values is used (that
#     is, the indexes of the form varname,instance-number).  Instances that
#     have been removed from Values[] (but are still listed in Order[]) are
#     not written.
# Input variables:
# Values[] and Order[] are as returned by ReadConfigFile().
# Comment, AssignOp, Escape, and Quote are as passed to ReadConfigFile().
# File is the name of the file to write to.
# If noQuotePattern is given, any value that does not match noQuotePattern will
# be quoted.
# Example:
# WriteConfigFile(Values, filename, "#", "=", "\\", "\"", Order,
#         "^[-[:alnum:]!@%_+=:,.]*$")
# In this example, values do not require quoting if they consist entirely of
# alphanums or characters from: !@%_+=:,. (safe for ksh evaluation)
function WriteConfigFile(Values, File, Comment, AssignOp, Escape, Quote, Order,
	noQuotePattern,

	i, ind, var, value)
{
    for (i = 1; ("instance",i) in Order; i++) {
	ind = Order["instance",i]
	if (ind in Values) {
	    var = substr(ind,1,index(ind,SUBSEP)-1)
	    value = Values[ind]
	    if (var != "" && var != Comment) {
		if (Quote != "" && Escape != "") {
		    if (index(value, Escape) || index(value, Quote) ||
			    index(value, "\n") ||
			    noQuotePattern != "" && value !~ noQuotePattern) {
			gsub(Quote, Escape Quote, value)
			value = Quote value Quote
		    }
		}
		else if (Escape != "") {
		    gsub(Escape, Escape Escape, value)
		    gsub("\n", Escape "\n", value)
		}
		value = var "=" value
	    }
	    print value > File
	}
    }
    return close(File)
}

# ReadLogicalLine: Read a logical line of input from File.  In the simplest
# case, the next physical line is read and returned.  Leading whitespace is
# removed.  Blank lines (lines that are empty or contain nothing but
# whitespace) are skipped.  Reading of a logical line is further modified by
# the following variables:
#
# Comment is the line-comment character.  If it is found as the first non-
# whitespace character on a line, the line is ignored.
#
# Escape is the escape character.  In general, the escape character removes the
# special meaning of the character that follows it; the escape character itself
# is removed.  Currently, there are three characters with special meanings:
# newlines, quotes, and the escape character itself.  If an escape character is
# followed by a newline, the line is joined to the following line and the
# escape character and newline are removed.  An escape character at the end of
# a comment line does NOT extend the comment line.  A comment character at the
# start of a physical line that is being joined to a previous line does not
# cause the line to be ignored.  If an escape character is followed by another
# escape character, they are replaced by one escape character.  See below for a
# description of escaping a quote character.  If an escape character is
# followed by any other character, the escape character is simply removed.
#
# Quote is the quote character.  From one instance of the quote character to
# the next, newlines are preserved.  If a physical line ends with quoting in
# effect, the next line is joined to it, with a newline embedded between them.
# This is different from escaping a newline; in both cases, the lines are
# joined, but in quotes the newline is preserved while an escaped newline is
# deleted.  Empty lines within quoted sections are not discarded; they result
# in a series of newlines in the returned value.  A quote character may be
# escaped by the escape character either inside or outside of a quoted section;
# an escaped quote character is taken literally, so it neither starts nor ends
# a quoted section.  Within a quoted section, this is the only special meaning
# of the escape character; if the escape character is followed by any other
# character, it is treated as a literal character and included in the returned
# value.
#
# Comment, Escape, and Quote behave roughly like the #, \, and " characters in
# the Bourne shell.  If any of them are null, the associated functionality does
# not exist.
#
# If ReturnAll is true, blank and comment lines will be returned.  Blank lines
# will be returned represented as single newlines regardless of whether or not
# they contained other whitespace.  Comment lines will be returned as lines
# that begin with the comment character, even if it was preceded by whitespace.
#
# Global variables: _rll_start is set to the physical line number that the
# returned logical line started on.  _rll_lnum[] is used to track the current
# line number.
#
# Return value: The logical line read.  At EOF, a null string is returned.  On
# error, a space followed by an error message is returned.  The error message
# begins with a numeric designation, separated from the rest of the message by
# a colon.

function ReadLogicalLine(File, Comment, Escape, Quote, Debug, ReturnAll,

	line, status, out, inQuote, inEsc, c, cPos, quotePos, escPos, lnum,
	errno)
{
    lnum = _rll_lnum[File]
    # Get first line
    while ((status = (getline line < File)) == 1) {
	lnum++
	sub("^[ \t]+","",line)	# discard leading whitespace
	# Skip blank & comment lines (break loop only for content lines)
	if (line != "" && substr(line,1,1) != Comment)
	    break
	else if (ReturnAll) {
	    _rll_lnum[File] = _rll_start = lnum
	    return line == "" ? "\n" : line
	}
	else
	    # Make sure we do not exit with line set to a comment if a comment
	    # is the last line in the file.
	    line = ""
    }
    if (status <= 0) {
	if (Debug > 8)
	    printf "Closing %s (read status %d)\n",File,status > "/dev/stderr"
	errno = ERRNO	# save this because it may be changed by close()
	close(File)
	lnum = _rll_lnum[File] = 0
    }
    if (status < 0)
	return " 1:Error reading from file " File ": " errno
    _rll_start = lnum
    if ((Escape == "" || index(line, Escape) == 0) &&
	    (Quote == "" || index(line, Quote) == 0)) {
	_rll_lnum[File] = lnum
	return line
    }
    inEsc = inQuote = 0
    out = ""
    while (line != "") {
	if (inEsc) {
	    out = out substr(line,1,1)
	    line = substr(line,2)
	    inEsc = 0
	}
	else {
	    if (Quote != "")
		quotePos = index(line, Quote)
	    if (Escape != "")
		escPos = index(line, Escape)
	    cPos = (quotePos > 0 && (escPos == 0 || quotePos < escPos)) ? \
		    quotePos : escPos
	    if (cPos > 0) {
		out = out substr(line,1,cPos-1)
		c = substr(line,cPos,1)
		line = substr(line,cPos+1)
		if (c == Quote)
		    inQuote = !inQuote
		else if (!inQuote || substr(line,1,1) == Quote)
		    inEsc = 1
		else
		    out = out c
	    }
	    else {
		out = out line
		line = ""
	    }
	}
	if (line == "" && (inEsc || inQuote)) {
	    if (inQuote)
		out = out "\n"
            while ((status = (getline line < File)) == 1 && inQuote && \
		    index(line, Quote) == 0) {
		out = out line "\n"
                lnum++
	    }
            if (status == 1)
                lnum++
	    else {
		errno = ERRNO	# save this because it may be changed by close()
		close(File)
		lnum = _rll_lnum[File] = 0
	    }
	    if (status < 0)
		return " -1:Error reading from file " File ":" ERRNO
	    if (!status) {
		if (inEsc)
		    return \
		    " -2:Error in file " File ": Escape character at EOF"
		else
		    return \
		    " -2:Error in file " File ": EOF within quoted section"
	    }
	    inEsc = 0
	}
    }
    _rll_lnum[File] = lnum
    return out
}

# ReadLogicalLines: Read a file and return its contents in Lines[] with one
# logical line per integer index starting at 1.  See ReadLogicalLine()
# for a description of the other parameters.
# The physical line number that each logical line started on is returned in
# LineNums[].
# Return value: On success, the number of logical lines read (the highest
# index in Lines[]).  On failure, a string describing the error, starting with
# a negative number.
function ReadLogicalLines(File, Comment, Escape, Quote, Lines, LineNums, Debug,
	ReturnAll,

	num, line)
{
    num = 0
    while ((line = ReadLogicalLine(File, Comment, Escape, Quote, Debug,
	    ReturnAll)) != "") {
	if (Debug > 9)
	    printf "Got config line: %s\n",line > "/dev/stderr"
	if (substr(line,1,1) == " ")
	    return "-" substr(line,2)
	Lines[++num] = line
	LineNums[num] = _rll_start
    }
    return num
}

# mkVarMap: Make a lookup table to map option variable names to option letters.
#
# Input variables:
#
# OptList, VarNames, and EnvSearch are as described for Opts().
#
# Output variables:
# 
# Var2Char[]: For each variable name in VarNames, an element is stored in
# Var2Char[] that maps that variable name to the corresponding option letter.
#
# VarInfo[]: If OptList specifies a (getopts-style) type character for the
# option, that character is stored in VarInfo[] under the same variable-name
# index.  For variables that should be searched for in the environment (per
# EnvSearch), the index VarInfo[variable-name,"e"] is also created, with no
# value.
#
# Globals, return value: None.

function mkVarMap(OptList, VarNames, EnvSearch, Var2Char, VarInfo,

	NumVars, i, optListInd, Vars, Type, Var)
{
    NumVars = split(VarNames,Vars,",")
    optListInd = 1
    if (EnvSearch == -1)
	EnvSearch = NumVars
    for (i = 1; i <= NumVars; i++) {
	Var = Vars[i]
	Var2Char[Var] = substr(OptList,optListInd++,1)	# Get option letter
	Type = substr(OptList,optListInd,1)		# Get option type
	if (Type ~ "^[:;*()#<>&]$") {
	    VarInfo[Var] = Type
	    optListInd++
	}
	if (i <= EnvSearch)
	    VarInfo[Var,"e"]
    }
}

# Given a path, performs a substitution for certain leading first-component
# values, where the leading component is the part of the path up through the
# first /, or the entire path if the path contains no /
# The substitutions are:
# ~ is replaced with the value of the HOME environment variable.
# $varname is replaced with the value of the varname environment variable,
#     if varname is a legal environment variable name.  If a leading $ is
#     followed by a string that is not a legal environment variable name,
#     no substitution is performed and no error is indicated.
# Input variables:
# path is the path to perform substitutions on.
# If unsetOK is true, it is not an error for a referenced environment variable
#     to not be set.  In this case, its value is taken to be the null value.
# Return value:
# On success, the path with substition (if one is performed) is returned.
# On error, the returned value consists of a null character followed by a
# message describing the error.
# The errors that can occur (if unsetOK is not true) are:
# ~ is used but the HOME environment variable is not set
# A varname is used but the corresponding environment variable is not set
function expandPathPrefix(path, unsetOK,

	firstComponent, envVar, varVal)
{
    firstComponent = path
    sub("/.*", "", firstComponent)
    if (firstComponent == "~")
	envVar = "HOME"
    else if (match(firstComponent, /^\$[_[:alpha:]][_[:alnum:]]*$/))
	envVar = substr(firstComponent, 2)
    if (envVar != "") {
	if (envVar in ENVIRON)
	    varVal = ENVIRON[envVar]
	else if (!unsetOK)
	    return "\0Referenced environment variable not set: $" envVar
	path = varVal substr(path, length(firstComponent) + 1)
    }
    return path
}

# Get variable assignments from environment and rcfiles.
#
# Input variables:
#
# rcFiles is as described for Opts().
#
# Var2Char[] maps variable names to option characters.
#
# OptParms[]: Option parameter information (option type and bounds), as
# generated by _parseGetoptsOptList()/_parseVarDesc() and used by _assignVal().
#
# VarInfo[] maps variable names to type characters, and also indicates whether
# each variable should be searched for in the environment (see mkVarMap()).
#
# Typically, mkVarMap() will be used to convert an option-list and
# variable-name-list into the Var2Char[] and VarInfo[] datasets required by
# this function.
#
# If Debug is true, debugging information is printed to stderr.
#
# If cfMustExist is true, it is an error for a config file to not exist.
#
# Output variables:
#
# Data is stored in Options[].
#
# Global variables:
#
# Sets _procArgv_err.  Uses ENVIRON[].
#
# If anything is read from any of the rcfiles, sets global READ_RCFILE to 1.
#
# Return value: An integer.
#
# On failure, one of the negative values returned by _assignVal(), or -1 for
# other failures.
#
# On success, 0.

function InitOpts(rcFiles, Options, Var2Char, OptParms, VarInfo, Debug,
	cfMustExist,

	Line, Var, Pos, Type, Ret, i, rcFile, fNames, numrcFiles, filesRead,
	Err, Assignments, retStr, variableCounts, OptNum, instance,
	numVarInstances)
{
    split("",filesRead,"")	# make awk know this is an array
    Ret = 0

    # Process environment first, since values assigned there should take
    # priority
    OptNum = 0
    for (Var in Var2Char) {
	if ((Var,"e") in VarInfo && Var in ENVIRON &&
	(Err = _assignVal(Var2Char[Var],ENVIRON[Var],Options,OptParms,1,Var,
		++OptNum,"e")) < 0)
	    return Err
    }

    numrcFiles = split(rcFiles,fNames,":")
    for (i = 1; i <= numrcFiles; i++) {
	rcFile = expandPathPrefix(fNames[i])
	if (substr(rcFile, 1, 1) == "\0") {
	    if (Debug > 0)
		printf "Skipping configuration file %s: %s\n", fNames[i], substr(rcFile, 2) > "/dev/stderr"
	    continue
	}

	# rcfiles are liable to be given more than once, e.g. UHOME and HOME
	# may be the same
	if (rcFile in filesRead)
	    continue
	filesRead[rcFile]

	split("", Assignments)
	split("", variableCounts)
	retStr = ReadConfigFile(Assignments, variableCounts, rcFile, "#", "=", "\\", "\"",
		0, "", 1, Debug)
	if (Debug > 3)
	    printf "Done processing configuration file %s\n", rcFile > "/dev/stderr"
	if ((retStr+0) > 0) {
	    READ_RCFILE = 1
	    READ_RCFILE += 0	# so awklint will not complain about single use
	}
	else if (retStr+0 < (cfMustExist ? 0 : -1)) { # If any failure other than cannot read file
	    sub(/^[^:]*:/,"",retStr)
	    _procArgv_err = retStr
	    Ret = -1
	}
	OptNum = 0
	for (Var in variableCounts)
	    if (Var in Var2Char) {
		numVarInstances = variableCounts[Var]
		for (instance = 1; instance <= numVarInstances; instance++)
		    if ((Err = _assignVal(Var2Char[Var],
			    Var in Assignments ? Assignments[Var,instance] : "",
			    Options, OptParms, Var in Assignments, Var,
			    ++OptNum, "f", rcFile)) < 0)
			return Err
	    }
	    else {
		_procArgv_err = sprintf(\
			"Unknown var \"%s\" assigned to on line %d\n"\
			"of file %s", Var, Assignments[Var,"lnum"],rcFile)
		Ret = -1
	    }
    }
    return Ret
}

# OptSets is a semicolon-separated list of sets of option sets.
# Within a list of option sets, the option sets are separated by commas.  For
# each set of sets, if any option in one of the sets is in Options[] AND any
# option in one of the other sets is in Options[], an error string is returned.
# If no conflicts are found, nothing is returned.
# Example: if OptSets = "ab,def,g;i,j", an error will be returned due to
# the exclusions presented by the first set of sets (ab,def,g) if:
# (a or b is in Options[]) AND (d, e, or f is in Options[]) OR
# (a or b is in Options[]) AND (g is in Options) OR
# (d, e, or f is in Options[]) AND (g is in Options)
# An error will be returned due to the exclusions presented by the second set
# of sets (i,j) if: (i is in Options[]) AND (j is in Options[]).
# todo: make options given on command line unset options given in config file
# todo: that they conflict with.
# todo: Let a null string given for a ; option unset the option.
function ExclusiveOptions(OptSets, Options,

	Sets, SetSet, NumSets, Pos1, Pos2, Len, s1, s2, c1, c2, ErrStr, L1, L2,
	SetSets, NumSetSets, SetNum, OSetNum)
{
    NumSetSets = split(OptSets,SetSets,";")
    # For each set of sets...
    for (SetSet = 1; SetSet <= NumSetSets; SetSet++) {
	# NumSets is the number of sets in this set of sets.
	NumSets = split(SetSets[SetSet],Sets,",")
	# For each set in a set of sets except the last...
	for (SetNum = 1; SetNum < NumSets; SetNum++) {
	    s1 = Sets[SetNum]
	    L1 = length(s1)
	    for (Pos1 = 1; Pos1 <= L1; Pos1++)
		# If any of the options in this set was given, check whether
		# any of the options in the other sets was given.  Only check
		# later sets since earlier sets will have already been checked
		# against this set.
		if ((c1 = substr(s1,Pos1,1)) in Options)
		    for (OSetNum = SetNum+1; OSetNum <= NumSets; OSetNum++) {
			s2 = Sets[OSetNum]
			L2 = length(s2)
			for (Pos2 = 1; Pos2 <= L2; Pos2++)
			    if ((c2 = substr(s2,Pos2,1)) in Options)
				ErrStr = ErrStr "\n"\
				sprintf("Cannot give both %s and %s options.",
				c1,c2)
		    }
	}
    }
    if (ErrStr != "")
	return substr(ErrStr,2)
    return ""
}

# OptSets is a semicolon-separated list of pairs of option sets.
# The sets of each pair are separated by a comma.
# For each pair, if any option in the first element of the pair is in
# Options[], at least one of the options in the second element of the pair must
# be in Options.  If it is not, an error string is returned.
# If any failed dependencies are found, nothing is returned.
# Example: if OptSets = "ab,def;i,j", an error will be returned due to
# a failed dependency if either a or b is given and none of d, e, and f are
# given, or if i is given and j is not given.
# todo: combine this with ExclusiveOptions in some sensible way.
function DependentOptions(OptSets, Options,

	Sets, SetPair, Pos1, Pos2, s1, s2, c1, ErrStr, L1, L2, SetPairs,
	NumSetPairs)
{
    NumSetPairs = split(OptSets,SetPairs,";")
    # For each pair of sets...
    for (SetPair = 1; SetPair <= NumSetPairs; SetPair++) {
	if (split(SetPairs[SetPair],Sets,",") != 2)
	    return "Bad dependent option list given - wrong number of sets in " SetPairs[SetPair] "; should be 2"
	s1 = Sets[1]
	s2 = Sets[2]
	L1 = length(s1)
	L2 = length(s2)
	for (Pos1 = 1; Pos1 <= L1; Pos1++)
	    # If any of the options in the first set was given, check whether
	    # any of the options in the second set was given.
	    if ((c1 = substr(s1,Pos1,1)) in Options) {
		for (Pos2 = 1; Pos2 <= L2; Pos2++)
		    if (substr(s2,Pos2,1) in Options)
			break
		if (Pos2 > L2)
		    ErrStr = ErrStr "\n"\
		    ( (L2 == 1) ? \
			    sprintf("Cannot give %s option unless %s option is given", c1, s2) : \
			    sprintf("Cannot give %s option unless one of these options is given: %s", c1, s2))
	    }
    }
    return substr(ErrStr,2)
}

# The value of each instance of option Opt that occurs in Options[] is made an
# index of Set[].
# If Sep is given, the value of each instance is split on this pattern,
# and each resulting string is treated as a separate value.
# The return value is the number of unique values added to Set[].
function Opt2Set(Options, Opt, Set, Sep,

	OptVals, i, n, tot, val)
{
    n = Opt2Arr(Options, Opt, OptVals, Sep)
    tot = 0
    for (i = 1; i <= n; i++) {
	val = OptVals[i]
	if (!(val in Set)) {
	    Set[val]
	    tot++
	}
    }
    return tot
}

# The value of each instance of option Opt that occurs in Options[] that
# begins with "!" is made an index of nSet[] (with the ! stripped from it).
# Other values are made indexes of Set[].
# If Sep is given, the value of each instance is split on this pattern,
# and each resulting string is treated as a separate value.  In this case,
# a leading ! affects only the value that it immediately precedes.
# The return value is the number of unique values stored.
function Opt2Sets(Options, Opt, Set, nSet, Sep,

	value, aSet, ret)
{
    ret = Opt2Set(Options, Opt, aSet, Sep)
    for (value in aSet)
	if (substr(value,1,1) == "!")
	    nSet[substr(value,2)]
	else
	    Set[value]
    return ret
}

# The value of each instance of option Opt that occurs in Options[] that
# begins with "!" is stored in optData[] under the index "e",n where n
# is an integer starting with 1 ("e" as in "exclusive").
# Other values are stored similarly under the major index "i" (as in
# "inclusive").
# The total number of instances that begin with "!" are stored in optData["e"],
# and the total number that do not are stored in optData["i"].
#
# The return value is the number of instances of Opt in Options.
# optData[] is suitable for passing to MatchOpt().
# If lowcase is true, all values are pushed to lower case.
# If fixed is true, the operation record is a fixed string matching.
#    If not, it is a regular expression matching.
function Opt2CompSets(Options, Opt, optData, lowcase, fixed,

	value, numOpt, OptVals, includerCount, excluderCount, varname)
{
    includerCount = excluderCount = 0
    numOpt = Opt2Arr(Options, Opt, OptVals)
    for (i = 1; i <= numOpt; i++) {
	value = OptVals[i]
	if (lowcase)
	    value = tolower(value)
	if (substr(value,1,1) == "!") {
	    optData["ev", ++excluderCount] = substr(value,2)
	    optData["ep", excluderCount] = !fixed
	}
	else {
	    optData["iv", ++includerCount] = value
	    optData["ip", includerCount] = !fixed
	}
    }
    optData["i"] = includerCount
    optData["e"] = excluderCount
    return includerCount + excluderCount
}

# Generate a set of complementary sets.
# The values assigned to option Opt in Options should be of the form
# varname=value or varname!=value.  If patOrFixed is given (see below),
# varname~value and varname!~value are also allowed.  If noAssignOp is
# 1, the forms varname and !varname are also allowed.
# Data is stored in optData[] as described for Opt2CompSets, but with all
# values prefixed by the variable name followed by SUBSEP.
# Also, optData[1..n] are set to the names of the variables seen.
# varNames[], if passed, is made the set of variable names seen.
# optData[] is suitable for passing to multiMatchOpt().
# If lowcase is true, all values are pushed to lower case.
# If Pat is given, all variable names are required to match it (after
#     being pushed to lower case, if Lower is true).
# If validVars[] contains any elements, then only variables whose names are
#     indexes of validVars[] are considered legitimate.
# If patOrFixed is given, the comparison operator can be either [!]~ or [!]= to
#     specify regular expression or fixed string matching respectively.
#     The indicated operation is recorded in optData.  If patOrFixed is not
#     given, the operator must be [!]=, but is treated as [!]~; that is, the
#     operation recorded is regular expression matching rather than fixed
#     string matching.
# If varSepPat is given, it is treated as a pattern to split varname on.  The
#     result is as though each resulting varname had been given separately.
# If noAssignVar is given and noAssignOp is zero, assignments that do not
#     include an assignment operator are treated as values prefixed by
#     noAssignVar, which should be a variable name followed by an assignment
#     operator.
# On success, a null string is returned.
# On error, an error message is returned.
# To test whether any instances of Opt were passed, use (1 in optData)
function OptSel2CompSets(Options, Opt, optData, lowcase, Pat, validVars,
	varNames, noAssignOp, patOrFixed, varSepPat, noAssignVar,

	varVals, allVarVals, varname, i, numInstance, varNamesGiven, junk,
	value, varNum)
{
    if (varValOpt(Options, Opt, varVals, allVarVals,
	    patOrFixed ? "!?[~=]" : "!?=", lowcase, Pat, noAssignVar,
	    noAssignVar != "" ? 3 : noAssignOp, "!", varSepPat) == -1)
	return _varValOpt_err
    for (junk in validVars) {
	varNamesGiven = 1
	break
    }
    for (varname in varVals) {
	if (varNamesGiven && !(varname in validVars))
	    return "Invalid variable name: " varname
	optData[++varNum] = varname
	varNames[varname]
	numInstance = allVarVals[varname, "count"]
	for (i = 1; i <= numInstance; i++) {
	    value = allVarVals[varname, i]
	    sep = allVarVals[varname, i, "sep"]
	    if (!patOrFixed)
		sub("=", "~", sep)
	    if (sep == "")
		optData[varname, "E"] = allVarVals[varname, i, "prefix"] != "!"
	    else {
		incex = index(sep, "!") ? "e" : "i"
		optData[varname, incex "v", ++optData[varname, incex]] = value
		optData[varname, incex "p", optData[varname, incex ]] = index(sep, "~") != 0
	    }
	}
    }
    return
}

# Match value against the patterns in optData[], which are stored as in
# Opt2CompSets().  The patterns are treated as either fixed strings or standard
# regular expressions, depending on the comparison operator used in the setup.
# If prefix is given, the indexes in optData[] are prefixed with it.
# In order for the return value to be true, value must not match any of the
# exclusive patterns and must match all of the inclusive patterns.  If an
# existence check is given, varGiven must be passed to tell whether the
# variable was seen.  A failed existence check (whether the requirement is that
# the variable does or does not exist) is sufficient to cause a match failure.
# A successful must-exist check is not sufficient to cause a match success;
# this allows a specification that a variable must exist and must have a null
# value, since a null-value pattern by itself will also match a variable that
# is not given.
# Return value:
# 1 for a match, 0 for no match.
function MatchOpt(optData, value, prefix, varGiven,

	includerCount, excluderCount, i)
{
    if ((prefix "E" in optData))
	if (varGiven != optData[prefix "E"])
	    return 0
    excluderCount = optData[prefix "e"]
    for (i = 1; i <= excluderCount; i++)
	if (optData[prefix "ep", i] ? value ~ optData[prefix "ev", i] : value == optData[prefix "ev", i])
	    return 0
    includerCount = optData[prefix "i"]
    for (i = 1; i <= includerCount; i++)
	if (optData[prefix "ip", i] ? value !~ optData[prefix "iv", i] : value != optData[prefix "iv", i])
	    return 0
    return 1
}

# Match values against the patterns in optData[], which are stored as in
# OptSel2CompSets().  The patterns are treated as standard regular expressions.
# values[] should contain strings to match against the patterns, indexed by the
# same variable names that are used as the first index of optData[].
# In order for the return value to be true, value must not match any of the
# exclusive patterns and must match all of the inclusive patterns.
function multiMatchOpt(optData, values,

	varnum, var)
{
    for (varnum = 1; varnum in optData; varnum++) {
	var = optData[varnum]
	if (!MatchOpt(optData, var in values ? values[var] : "", var SUBSEP, var in values))
	    return 0
    }
    return 1
}

# The value of each instance of option Opt that occurs in Options[] is made an
# element of OptVals[], with indexes starting with 1.
# The return value is the number of instances of Opt in Options.
# If Sep is given, the value of each instance is split on this pattern,
# and each resulting string is treated as a separate value.
# Return value: The number of values stored in OptVals[].
function Opt2Arr(Options, Opt, OptVals, Sep,

	numInst, instance, i, nVals, elem, valNum)
{
    if (!(Opt in Options))
	return 0
    i = 0
    numInst = Options[Opt,"count"]
    for (instance = 1; instance <= numInst; instance++)
	if (Sep) {
	    nVals = split(Options[Opt,instance],elem,Sep)
	    for (valNum = 1; valNum <= nVals; valNum++)
		OptVals[++i] = elem[valNum]
	}
	else
	    OptVals[++i] = Options[Opt,instance]
    return i
}

# Returns a list of the options in the string OptList that were given,
# as indicated by the data in Options[].
# If any of Arg, Env, or File are true, the given opts are only considered to
# have been set if they were set in the command line arguments, environment,
# or in a configuration file, respectively.
# The first instance of each option that was set is set in Results[], with the
# values (if any) assigned to it.
# The list of options found is also returned in Results["list"].
function OptsGiven(Options, OptList, Arg, Env, File, Results,

	numOpt, i, Opt, instance, Source, count)
{
    if (!Arg && !Env && !File)
	Arg = Env = File = 1
    numOpt = length(OptList)
    count = 0
    for (i = 1; i <= numOpt; i++) {
	Opt = substr(OptList,i,1)
	for (instance = 1; (Opt,"num",instance) in Options; instance++) {
	    Source = Options[Opt,"source",instance]
	    if (Arg && Source == "a" || File && Source == "f" ||
		    Env && Source == "e") {
		Results[Opt] = Options[Opt,instance]
		Results["list"] = Results["list"] Opt
		count++
		break
	    }
	}
    }
    return Results["list"]
}

# Determine the order in which the options in OptList were given.
# Source specifies the source to examine.  It should consist of one of
# a, e, and f, indicating the argument list, environment, and config files.
# For each option in OptList that was given in the specified source, Order[num]
# is set to the relative position of the first instance of that option, with
#     num starting with 1.
# The number of options found is returned.
# This requires some gawk features.
function optOrder(Options, OptList, Source, Order,

	i, checkOpts, Elem, sInd)
{
    split(OptList, checkOpts, "")
    for (i = 1; i in checkOpts; i++)
	if (checkOpts[i] in Options)
	    Elem[Options[checkOpts[i], "num", 1]] = checkOpts[i]
    asorti(Elem, sInd)
    for (i = 1; i in sInd; i++)
	Order[i] = Elem[sInd[i]]
    return i - 1
}

# A list of options is passed in the string OptList.
# These options are searched for first in the options set on the command
# line; if no such were given, then in the options set in the environment;
# and if no such were given, then in the options set in the configuration
# files.  The resulting options are set in the array Results[], with their
# values (if any) assigned to them.  Only the first instances of options are
# copied to Results[].
# In other words, when a source is found that has any of the options set in it,
# any options set in that source are copied to Results[] and searching ceases.
# Results["list"] is set to the list of options found.
# Return value: Same as Results["list"]
function prioOpt(Options, OptList, Results,

	list)
{
    if ((list = OptsGiven(Options,OptList,1,0,0,Results)) != "")
	return list
    else if ((list = OptsGiven(Options,OptList,0,1,0,Results)) != "")
	return list
    else if ((list = OptsGiven(Options,OptList,0,0,1,Results)) != "")
	return list
    return ""
}

# addPseudoOpt(): Add a pseudo-option.
# Input variables:
# optDesc is the option description.
# Value is the value to assign to it.
# Output variables:
# The option value is stored in Options[]
# Return value:
# On success, a null string.
# On failure, a string describing the error.
function addPseudoOpt(varDesc, Value, Options,

	optParms, err)
{
    if ((err = _parseVarDesc(varDesc, optParms)) != "")
	return "Error in pseudo-option description \"" varDesc "\":\n" err
    if (_assignVal(optParms["options", 1, "char"], Value, Options, optParms, 1,
	    optParms["options", 1, "name"], 0, "p") < 0)
	return _procArgv_err "."
    return ""
}

# varValOpt: Process all instances of an option that takes an option-value of
# the form var=value.
# Input variables:
# Options[] is the option data.
# Opt is the option to process.
# If assignOp is given, it is used as the assignment operator, which separates
#     the variable name from the value.  It defaults to "=", and is treated as
#     a regular expression.
# If Lower is given, all variable names are pushed to lower case.
# If prefixPat is given, any prefix of the varible name that matches it is
#     removed from the variable name.
# If Pat is given, all variable names are required to match it (after
#     being pushed to lower case, if Lower is true).
# If noAssignOp is nonzero, option instances that do not include the assigment
#     operator are allowed.  If noAssign is 1, they are taken to consist
#     entirely of a variable name, with an implicit null value.  If noAssignOp
#     is 2, they are taken to consist entirely of values, with an implicit null
#     variable name.  These cases can be distinguished from instances that do
#     contain an assignment operator with a a null variable name or value by
#     checking the "sep" element described below.  If noAssignOp is 3, these
#     instances are processed as described for errVar, with the difference that
#     errVar will only apply to instances lacking an assignment operator;
#     instances with a bad variable name will result in an abort & error
#     return.
# If errVar is non-null, this function will not abort and return an error if a
#     bad variable name is given or if noAssignOp is zero and an option
#     instance does not include an assignment operator.  Instead, the entire
#     value of the option instance is assigned to the pseudo-variable name
#     given by errVar.  If errVar ends with text that matches assignOp, it
#     specifies the value stored for the "sep" data.  If not, no sep data is
#     stored.
# If varSepPat is given, the part of the option value before the assignment
#     operator is taken to be a list of varnames instead of a single varname,
#     separated by varSepPat.  The value on the righthand side of the
#     assignment operator is assigned to each of the variables named in the
#     list.
# Output variables:
# The results are stored in varVals[] and allVarVals[].
# allVarVals[varname,n] is set to the value given for the nth instance of
#     varname that is encountered.
# allVarVals[varname, n, "sep"] is set to the text that matched the assignment
#     operator pattern.
# If a prefix pattern is given and matched, allVarVals[varname, n, "prefix"] is
#     set to the value matched.
# allVarVals[varname,"count"] is set to the number of instances of varname that
#     are given.
# varVals[varname] is set identically to allVarVals[varname,1].
# For each option processed, allVarVals[,m,n] are set, with m being the option
#     instance number, n being the variable number, and the value being index
#     in allVarVals of the data stored for that variable.  For example, if
#     varSepPat is"," and two instances of Opt were given with values
#     foo,bar=baz and bar=baz, these values would be stored under the given
#     indexes:
#     [,1,1] = "foo" SUBSEP 1
#     [,1,2] = "bar" SUBSEP 1
#     [,2,1] = "bar" SUBSEP 2
# Return value:
# On success, the number of instances of Opt that were encountered.
# On failure, -1.  In this case, the global variable _varValOpt_err is set to a
#     string describing the problem.
# If errVar is passed, no failure return will occur.
function varValOpt(Options, Opt, varVals, allVarVals, assignOp, Lower, Pat,
	errVar, noAssignOp, prefixPat, varSepPat,

	assignment, OptVals, numOpt, optNum, varname, value, prefix, instance,
	vars, varNum, defSep)
{
    if (assignOp == "")
	assignOp = "="
    numOpt = Opt2Arr(Options,Opt,OptVals)
    if (prefixPat != "")
	prefixPat = "^(" prefixPat ")"
    if (match(errVar, assignOp "$")) {
	defSep = substr(errVar, RSTART)
	errVar = substr(errVar, 1, RSTART-1)
    }
    for (optNum = 1; optNum <= numOpt; optNum++) {
	assignment = OptVals[optNum]
	if (prefixPat != "" && match(assignment, prefixPat)) {
	    prefix = substr(assignment, RSTART, RLENGTH)
	    assignment = substr(assignment, RSTART+RLENGTH)
	}
	else
	    prefix = ""
	if (!(match(assignment,assignOp))) {
	    if (noAssignOp == 1) {
		RSTART = length(assignment) + 1
		RLENGTH = 0
	    }
	    else if (noAssignOp == 2) {
		RSTART = 1
		RLENGTH = 0
	    }
	    else if (errVar == "") {
		_varValOpt_err = "No instance of the separator \"" assignOp \
			"\" in this assignment: " assignment
		return -1
	    }
	}
	split("", vars)
	if (RSTART > 0) {
	    varname = substr(assignment,1,RSTART-1)
	    if (Lower)
		varname = tolower(varname)
	    if (varSepPat != "")
		split(varname, vars, varSepPat)
	    else
		vars[1] = varname
	    value = substr(assignment,RSTART+RLENGTH)
	}
	else {
	    vars[1] = errVar
	    value = assignment
	}
	for (varNum = 1; varNum in vars; varNum++) {
	    varname = vars[varNum]
	    if (RSTART > 0 && Pat != "" && varname !~ Pat) {
		if (errVar != "" && noAssignOp != 3)
		    varname = errVar
		else {
		    _varValOpt_err = \
			    "Invalid variable name in this assignment: " \
			    assignment
		    return -1
		}
	    }
	    instance = ++allVarVals[varname, "count"]
	    allVarVals[varname, instance] = value
	    allVarVals["", optNum, varNum] = varname SUBSEP instance
	    if (prefix != "")
		allVarVals[varname, instance, "prefix"] = prefix
	    if (RSTART > 0)
		allVarVals[varname, instance, "sep"] = \
			substr(assignment, RSTART, RLENGTH)
	    else if (defSep != "")
		allVarVals[varname, instance, "sep"] = defSep
	    if (instance == 1)
		varVals[varname] = value
	}
    }
    return numOpt
}
### End-lib ProcArgs
