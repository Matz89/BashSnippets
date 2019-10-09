#!/bin/bash
#
#This script will use args to generate local user account with a random password

#Check if root User; if not root then exit status 1 
ACCOUNT_CREATOR='0'
if [[ "${ACCOUNT_CREATOR}" -ne "${UID}" ]]
then
  echo "Please run as root. Exiting script."
  exit 1
fi

#Check for parameters; exit 1 if no parameters
if [[ ${#} -eq 0 ]]
then
	echo "Usage: ${0} USER_NAME [COMMENT]..."
	exit 1
fi

#Loop through positional parameters; get username and comment
USRNAME=${1}
shift

while [[ "${#}" -gt 0 ]]
do
	COMMENT="${COMMENT} ${1}"
	shift
done

#Create new User with above information
useradd --comment "${COMMENT}" --create-home ${USRNAME}

#If fails account creation; exit status 1
if [[ "${?}" -ne 0 ]]
then
  echo "User Account Creation Failed."
  exit 1
fi

#Generate Password
PASSWRD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c8)


#Set password and force expire it
echo ${PASSWRD} | passwd --stdin ${USRNAME}
passwd -e ${USRNAME}

#Display username, password, and host of account

echo "USER: ${USRNAME}"
echo "PASS: ${PASSWRD}"
echo "HOST: ${HOSTNAME}"
exit 0

