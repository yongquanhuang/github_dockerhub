#!/bin/bash
yum -y insatll nfs-utils
mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,soft,timeo=600,retrans=2 ${efs_dns_name}:/ /mnt/efs
echo "${efs_dns_name}:/ /mnt/efs nfs nfsvers=4.1,rsize=1048576,wsize=1048576,soft,timeo=600,retrans=2 0 0" >> /etc/fstab
