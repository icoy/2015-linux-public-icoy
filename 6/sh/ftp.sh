#!/bin/bash

source ./config.sh

#update downloading source
apt-get update 
if [[ $? -ne 0 ]]; then
	echo "apt-get update failed"
	exit
fi

# check installation
if [ -f /etc/vsftpd.conf.back ];then 
	echo "installation already finished"
else 
	apt install -y vsftpd && cp /etc/vsftpd.conf /etc/vsftpd.conf.back|| echo "installation failed" && exit	
fi

## create anonymous directory 
mkdir -p "$ANONY_DIR"
chown nobody:nogroup "$ANONY_DIR"



## create user directory

if [[ $(grep -c "^$user:" /etc/passwd) -eq 0 ]];then
	useradd "$user"
	echo "$user:" | chpasswd
else echo "user $user already exists"
fi

if [[ ! -d "$USER_DIR" ]];then mkdir "$USER_DIR" ;fi
chown nobody:nogroup "$USER_DIR"
chmod a-w "$USER_DIR"

WRITEABLE_DIR="${USER_DIR}/files"
mkdir -p "$WRITEABLE_DIR"
chown $user:$user "$WRITEABLE_DIR"



echo $user > /etc/vsftpd.userlist
echo anonymous >> /etc/vsftpd.userlist


#use existed configuration file

if [ ! -f /etc/vsftpd.conf.back ];then
	cp conf/vsftpd.conf /etc/vsftpd.conf
else
	cp /etc/vsftpd.conf /etc/vsftpd.conf.back
fi

#set host whitelist and blacklist
grep -q "vsftpd: ALL"  /etc/hosts.deny || echo "vsftpd: ALL" >> /etc/hosts.deny
grep -q "vsftpd:10.0.1.1"  /etc/hosts.deny || echo "vsftpd:10.0.1.1" >> /etc/hosts.allow

#exit
systemctl restart vsftpd


