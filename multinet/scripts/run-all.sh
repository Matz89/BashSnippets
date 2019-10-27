#!/bin/bash

#Does not allow user to run with superuser privileges
if [[ ${UID} -eq 0 ]]
then
	echo "ERROR: Cannot run this script as superuser" &>2
	exit 1
fi

#Option variables
FILE="./servers.txt"
DRY_RUN=false
REMOTE_SUDO=false
VERBOSE=false

#Usage function
usage () {
	echo "TODO: USAGE WORDS HERE"
}

#Verbose function
verbose () {
	echo "VERBOSE: ${1}"
}


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

#shift past optional args
shift $((OPTIND - 1))

#Verify FILE exists
if [[ ! -f "${FILE}" ]]
then
	echo "ERROR: ${FILE} does not exist!" &>2
	exit 1
fi
