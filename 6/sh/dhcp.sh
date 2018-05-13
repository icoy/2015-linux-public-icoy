#!/bin/bash

source ./config.sh


#update & install
apt-get update 
if [[ $? -ne 0 ]]; then
        echo "apt update failed"
        exit 0
fi
apt-get install isc-dhcp-server
if [[ $? -ne 0 ]]; then
        echo "install failed"
        exit 0
fi

#use existed configuration file
if [ ! -f /etc/dhcpd.conf.back ];then
	cp /conf/dhcpd.conf /etc/dhcp/dhcpd.conf
else
	cp /conf/dhcpd.conf /etc/dhcp/dhcpd.conf.back
fi

sed -i '/^INTERFACES/d' /etc/default/isc-dhcp-server
echo INTERFACES=\"$networkcard\" >>/etc/default/isc-dhcp-server

systemctl restart isc-dhcp-server.service
