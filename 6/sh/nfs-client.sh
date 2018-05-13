#!/bin/bash
source ./config.sh

#update & install
apt-get update 
if [[ $? -ne 0 ]]; then
        echo "apt update failed"
        exit 0
fi
apt-get install -y nfs-common
if [[ $? -ne 0 ]]; then
        echo "install failed"
        exit 0
fi

#creat amd mount folders
mkdir -p $nfs_clie1
mkdir -p $nfs_clie2

mount $nfs_host_ip:$nfs_host1 $nfs_clie1
mount $nfs_host_ip:$nfs_host2 $nfs_clie2

