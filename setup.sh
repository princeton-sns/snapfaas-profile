#!/bin/bash

# add cpu cgroup firecracker
sudo mount -o remount,ro -t cgroup /sys/fs/cgroup
sudo mkdir /sys/fs/cgroup/cpu/firecracker

# node 1
if [ $(uname -a | awk '{print $2}' | awk -F. '{print $1}') == 'node1' ]; then
    SSDDEV=$(lsblk -o NAME,ROTA | grep 0 | head -1 | awk '{print $1'})
    sudo mkdir /ssd
    sudo mkfs.ext4 /dev/$SSDDEV
    sudo mount /dev/$SSDDEV /ssd
    sudo chown -R $(uname -un):$(uname -gn) /ssd
fi

# node 2
if [ $(uname -a | awk '{print $2}' | awk -F. '{print $1}') == 'node2' ]; then
    .
fi