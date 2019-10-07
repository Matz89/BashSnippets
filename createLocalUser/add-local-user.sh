#!/bin/bash

#Check if root User; if not root then exit status 1 
ACCOUNT_CREATOR='0'
if [[ "${ACCOUNT_CREATOR}" -ne "${UID}" ]]
then
  echo "Please run as root. Exiting script."
  exit 1
fi

#prompt for username to be created
read -p "Account Username: " usrname

#prompt for Name of User; put into comment field
read -p "Name of Account User: " fullname

# prompt for initial password; this should be marked for change on first login (handled by linux)
read -p "Account Password: " passwrd

#Create new User with above information
useradd --comment "${fullname}" --create-home ${usrname}

#If fails account creation; exit status 1
if [[ "${?}" -ne 0 ]]
then
  echo "User Account Creation Failed."
  exit 1
fi

#Set password and force expire it
echo ${passwrd} | passwd --stdin ${usrname}
passwd -e ${usrname}

#Display username, password, and host of account

echo "USER: ${usrname}"
echo "PASS: ${passwrd}"
echo "HOST: ${HOSTNAME}"
exit 0

