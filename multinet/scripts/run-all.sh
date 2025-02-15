#!/bin/bash

#Does not allow user to run with superuser privileges
if [[ ${UID} -eq 0 ]]
then
	echo "ERROR: Cannot run this script as superuser" >&2
	exit 1
fi

#Option variables
FILE="./servers.txt"
DRY_RUN=false
REMOTE_SUDO=false
VERBOSE=false

#Usage function
usage () {
	echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
	echo "Executes COMMAND as a single command on every server." >&2
	echo "	-f FILE	Use FILE for the list of servers. Default ${FILE}." >&2
	echo "	-n	Dry run mode. Display the COMMAND without executing." >&2
	echo "	-s	Execute COMMAND using sudo on remote server. " >&2
	echo "	-v	Verbose output" >&2
	exit 1			
}

#Verbose function
verbose () {
	if [[ ${VERBOSE} = true ]]
	then
		echo "VERBOSE: ${1}"
	fi
}

#Perform command function
perform_cmd () {

	SERVER="${1}"
	COMMAND="${2}"

	if [[ ${REMOTE_SUDO} = true ]]
	then
	  COMMAND="sudo ${2}"
	fi

	verbose "${SERVER}: (running cmd) ${COMMAND}"
	if [[ ${DRY_RUN} = true ]] 
	then
		echo "DRY RUN (${SERVER}): ssh -o ConnectTimeout=2 ${SERVER} ${COMMAND}"
	else
		echo "ssh -o ConnectTimeout=2 $SERVER $COMMAND"
		ssh -o ConnectTimeout=2 ${SERVER} ${COMMAND}
		
	fi
	verbose "${SERVER}: (cmd exit status) ${?}"

}
echo "DRY_RUN: $DRY_RUN"
echo "SUDO: $REMOTE_SUDO"
echo "VERBOSE: $VERBOSE"

while getopts f:nsv OPTION
do
	case ${OPTION} in
		f)
			FILE="${OPTARG}"
			;;
		n)
			DRY_RUN=true
			;;
		s)
			REMOTE_SUDO=true
			;;
		v)
			VERBOSE=true
			;;
		?)
			usage
			exit 1
			;;
	esac
done

echo "DRY_RUN: $DRY_RUN"
echo "SUDO: $REMOTE_SUDO"
echo "VERBOSE: $VERBOSE"


#shift past optional args
shift $((OPTIND - 1))

#Verify FILE exists
verbose "Checking if file exists..."

if [[ ! -f "${FILE}" ]]
then
	echo "ERROR: ${FILE} does not exist!" >&2
	exit 1
fi

verbose "${FILE} exists!"
EXIT_STATUS="0"

for SERVER in $(cat ${FILE})
do
	perform_cmd ${SERVER} ${1}
done

