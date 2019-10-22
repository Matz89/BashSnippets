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
	USERNAME=${1}
	shift

	#Check if user exists
	USER_ID=$(id -u name > /dev/null 1>&2) 
	if [[ ${?} -ne 0 ]]
	then
		echo "FAILURE: ${USERNAME} does not exist."
		continue
	fi

	#Check if ID is valid
	if [[ ${USER_ID} -lt 1000 ]]
	then
		echo "FAILURE: ${USERNAME}, ID - ${USER_ID}, is a system account (ID<1000). Will not take action."
		continue
	fi

	#Perform action
	#Check if archiving home dir
	if [[ $ARCHIVE_ACCOUNT = true ]]
	then

		#Check if archive directory does not exists
		if [[ ! -d "./archives" ]]
		then
			mkdir archives
		fi

		#Archive home directory to archives directory
		tar -cf ${USERNAME}.tar ./archives

		if [[ ${?} -eq 0 ]]
		then
			echo "SUCCESS: ${USERNAME} home directory archived to ./archives/${USERNAME}.tar"
		else
			echo "FAILURE: ${USERNAME} home directory failed to archive"
		fi
	fi

	#Delete or disable account
	if [[ ${DELETE_ACCOUNT} = true ]]
	then
		if [[ ${REMOVE_HOME} = true ]]
		then
			#Delete account and remove home directory
			userdel -r ${USERNAME}

			if [[ ${?} -eq 0 ]]
			then
				echo "SUCCESS: ${USERNAME} account and home directories are deleted."
			else
				echo "FAILURE: ${USERNAME} account and home directory failed to be deleted."
			fi
			
		else
			#Delete account and preserve home directory
			userdel ${USERNAME}

			if [[ ${?} -eq 0 ]]
			then
				echo "SUCCESS: ${USERNAME} account is deleted."
			else
				echo "FAILURE: ${USERNAME} account failed to be deleted."
			fi
			
		fi
		#Delete account without removing home directory
	else
		#Disable account
		chage -E 0 ${USERNAME}

		if [[ ${?} -eq 0 ]]
		then
			echo "SUCCESS: ${USERNAME} account is disabled."
		else
			echo "FAILURE: ${USERNAME} account failed to be disabled."
		fi
		
	fi
done

exit 0
