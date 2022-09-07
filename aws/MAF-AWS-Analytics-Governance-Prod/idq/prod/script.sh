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
groupadd infausr
useradd -rg infausr infausr
chown -R infausr:infausr /app
cp /etc/security/limits.conf /etc/security/limits.conf-org
{ 
echo "infausr hard    nproc   62000" 
echo "infausr soft    nproc   62000"  
echo "infausr hard    nofile   62000"
echo "infausr soft    nofile   62000" 
} >>/etc/security/limits.conf
