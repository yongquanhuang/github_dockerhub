#!/bin/bash
mkfs -t ext4 /dev/sdb 
mkdir /iosp
mount  /dev/sdb   /iosp
echo  "/dev/sdb /iosp ext4 defaults 0 0" >> /etc/fstab
