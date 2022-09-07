#!/bin/bash
#script to mount secondary volume to EC2 as /app

until lsblk|grep xvdb;
do
sleep 5
done
file -s /dev/xvdb
mkfs -t ext4 /dev/xvdb
mkdir /app
mount /dev/xvdb /app
df -h /app
cp /etc/fstab /etc/fstab.bak
echo "/dev/xvdb /app    ext4    defaults,nofail 0   0">>/etc/fstab
mount -a
