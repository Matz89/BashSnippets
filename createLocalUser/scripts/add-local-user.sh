#!/bin/bash
#
#Create local user account

#Check if root User; if not root then exit status 1 
ACCOUNT_CREATOR='0'
NOW=$(date +"%Y-%m-%d %H:%M:%S")

if [[ "${ACCOUNT_CREATOR}" -ne "${UID}" ]]
then
  echo "[ ${NOW} ] Please run with sudo or as root. Exiting script." &>> ${ERRLOG}
  exit 1
fi

#Check for parameters; exit 1 if no parameters
if [[ ${#} -eq 0 ]]
then
	echo "[ ${NOW} ] Usage: ${0} USER_NAME [COMMENT]..." >&2
	echo "[ ${NOW} ] Must supply a USER_NAME parameter." >&2
	exit 1
fi

#Loop through positional parameters; get username and comment
USRNAME=${1}
shift

COMMENT=${@}

#Create new User with above information
useradd --comment "${COMMENT}" --create-home ${USRNAME} &> /dev/null

#If fails account creation; exit status 1
if [[ "${?}" -ne 0 ]]
then
  echo "[ ${NOW} ] User Account Creation Failed." >&2 
  exit 1
fi

#Generate Password
PASSWRD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c8)

#Set password and force expire it
echo ${PASSWRD} | passwd --stdin ${USRNAME} &> /dev/null
passwd -e ${USRNAME} &> /dev/null

if [[ "${?}" -ne 0 ]]
then
	echo "[ ${NOW} ] Failed to set password for ${USRNAME} account." >&2 
fi

#Display username, password, and host of account

echo "USER: ${USRNAME}"
echo "PASS: ${PASSWRD}"
echo "HOST: ${HOSTNAME}"

#Cleanup error log file
rm ${ERRLOG} > /dev/null

exit 0

