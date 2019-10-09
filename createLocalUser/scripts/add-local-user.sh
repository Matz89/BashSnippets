#!/bin/bash
#
#This script will prompt for user information; then create a local account


#Check if root User; if not root then exit status 1 
ACCOUNT_CREATOR='0'
if [[ "${ACCOUNT_CREATOR}" -ne "${UID}" ]]
then
  echo "Please run as root. Exiting script."
  exit 1
fi

#prompt for username to be created
read -p "Account Username: " USRNAME

#prompt for Name of User; put into comment field
read -p "Name of Account User: " FULLNAME

# prompt for initial password; this should be marked for change on first login (handled by linux)
read -p "Account Password: " PASSWRD

#Create new User with above information
useradd --comment "${FULLNAME}" --create-home ${USRNAME}

#If fails account creation; exit status 1
if [[ "${?}" -ne 0 ]]
then
  echo "User Account Creation Failed."
  exit 1
fi

#Set password and force expire it
echo ${PASSWRD} | passwd --stdin ${USRNAME}
passwd -e ${USRNAME}

#Display username, password, and host of account

echo "USER: ${USRNAME}"
echo "PASS: ${PASSWRD}"
echo "HOST: ${HOSTNAME}"
exit 0

