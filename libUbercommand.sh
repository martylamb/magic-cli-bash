#!/bin/bash
#
# A bash tool similar to Slack's magic-cli : A foundation for building
# your own suite of command line tools.
#
# See https://github.com/martylamb/magic-cli-bash for more details

UBERCOMMAND_DESC=${UBERCOMMAND_DESC:-FIXME: set a description via the UBERCOMMAND_DESC variable}

# ----------------------------------------------------------------------

UBER_DIRNAME=$( dirname "$0" )
UBER_BASECMD=$( basename "$0" )

# ----------------------------------------------------------------------

# extracts usage text from a single subcommand script (not including subcommand)
# $1 is path to script
function usageTextOfScript() {
	local BASESUBCMD="$( basename $1 )"
	local USAGE=$( cat "$1" | egrep -i "# *usage: *" | sed -e 's/.*# *usage: *//I' )
	printf "${UBER_BASECMD} %s\t%s\n" ${BASESUBCMD#$"$UBER_BASECMD-"} "${USAGE}"
}

# ----------------------------------------------------------------------

# given a subcommand (with no path or basecmd prefix), provides the full
# path to the subcommand script
# $1 is the subcommand
function pathToSubcommandScript() {
	echo "${UBER_DIRNAME}/${UBER_BASECMD}-$1"
}

# ----------------------------------------------------------------------

# given a list of zero or more subcommands, expands them to their paths and
# sorts the result.  if zero subcommands are specified, expands all available
# subcommands
function expandSubcommands() {
	if [ $# -eq 0 ]; then
		ls ${UBER_DIRNAME}/${UBER_BASECMD}-*
	else
		for SUBCMD in $@; do ls "${UBER_DIRNAME}/${UBER_BASECMD}-${SUBCMD}"; done | sort
	fi
}

# ----------------------------------------------------------------------

# provides formatted usage information.  If no arguments are specified,
# shows usage of all commands.  Otherwise provides usage of the subcommands
# specified in the list
function usage() {
	printf "\n${UBER_BASECMD} - ${UBERCOMMAND_DESC}\n\nUsage:\n"
	
	for SUBCMD in $( expandSubcommands $@ ) ; do usageTextOfScript $SUBCMD ; done \
		| column --table -R 1 -s $'\t' --output-separator "    " \
		| sed -e 's/^/    /'
		
	echo ""
	echo "Type '${UBER_BASECMD} help SUBCOMMAND' for detailed help on any subcommand."
	echo ""
}

# ----------------------------------------------------------------------

if [ $# -eq 0 ]; then
	usage
else
	case $1 in
		help|--help|-h|-\?) 	[ $# -eq 1 ] && usage || $(pathToSubcommandScript "$2") --help
								;;
								
		*) 						SUBCOMMAND=$(pathToSubcommandScript "$1")
								shift
								${SUBCOMMAND} $@
	esac
fi
