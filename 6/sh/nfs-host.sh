#!/bin/bash
source ./config.sh

#update & install
apt-get update 
if [[ $? -ne 0 ]]; then
        echo "apt update failed"
        exit 0
fi
apt-get install -y nfs-kernel-server 
if [[ $? -ne 0 ]]; then
        echo "install failed"
        exit 0
fi

#creat amd mount folders
mkdir $nfs_host1 -p
chown nobody:nogroup $nfs_host1

#revise file /etc/exports to change previleges
touch /etc/exports
cat<<EOT >/etc/exports
$nfs_host1   $nfs_clie_ip(rw,sync,no_subtree_check)
$nfs_host2   $nfs_clie_ip(sync,no_root_squash,no_subtree_check)
EOT


systemctl restart nfs-kernel-server
