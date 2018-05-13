#!/bin/bash

source ./config.sh


#update & install
apt-get update 
if [[ $? -ne 0 ]]; then
        echo "apt update failed"
        exit 0
fi
apt-get install samba
if [[ $? -ne 0 ]]; then
        echo "install failed"
        exit 0
fi



useradd -M -s /sbin/nologin "$samuser"

passwd "$samuser"
smbpasswd -a "$samuser"

cat<<EOT >>/etc/samba/smb.conf
[guest]
path = /home/samba/guest/
read only = yes
guest ok = yes
[demo]
path = /home/samba/demo/
read only = no
guest ok = noif [[ $? -ne 0 ]]; then
        echo "install failed"
        exit 0
fi

force create mode = 0660
force directory mode = 2770
force user = "$samuser"
force group = "$samgroup"
EOT

smbpasswd -e "$smauser"
groupadd "$samgroup"
usermod -G "$samgroup" "$samuser"
mkdir -p /home/samba/guest/
mkdir -p /home/samba/demo/
chgrp -R "$samgroup" /home/samba/guest/
chgrp -R "$samgroup" /home/samba/demo/
chmod 2775 /home/samba/guest/
chmod 2770 /home/samba/demo/

systemctl restart smbd 
