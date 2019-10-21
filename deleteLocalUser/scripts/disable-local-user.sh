#!/bin/bash

#Must be executed with superuser privileges. Return 1. Display on stderr
if [[ ${UID} -ne 0 ]]
then
	>&2 echo "Permission denied. Please run script with root access."
	exit 1
fi

#Usage statement
usage(){
	>&2 echo "Usage: ${0} [-rda] USERNAME1 [USERNAME2 ...]"
	>&2 echo "Disable user accounts."
	>&2 echo "	-d	Marks account for deletion"
	>&2 echo "	-r	Removed home directory associated with account"
	>&2 echo "	-a	Archives the home directory associated with account"
	>&2 echo ""

}

DELETE_ACCOUNT=false
REMOVE_HOME=false
ARCHIVE_ACCOUNT=false

#Check for args; supply usage statement if no username supplied; exit 1. Display on stderr
while getopts dra OPTION
do
	case ${OPTION} in
		d)
			DELETE_ACCOUNT=true
			;;
		r)
			REMOVE_HOME=true
			;;
		a)
			ARCHIVE_ACCOUNT=true
			;;
		?)
			usage
			exit 1
			;;
	esac
done

#Shift past optional args
shift $((OPTIND - 1))

#Ensure username arg exists
if [[ "${#}" -eq 0 ]]
then
	usage
	exit 1
fi

#Perform actions for each username
while [[ "${#}" -gt 0 ]]
do
	
	#Check if user exists

	#Check if ID is valid

	#Perform action

	#Provide result

	shift
done
