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
    sudo chown -R $(id -un):$(id -gn) /ssd
fi

# node 2
if [ $(uname -a | awk '{print $2}' | awk -F. '{print $1}') == 'node2' ]; then
    COUCHDBURL='http://admin:admin@localhost:5984'
    curl -X PUT $COUCHDBURL/reminders
    curl -X PUT $COUCHDBURL/images
    curl -X PUT $COUCHDBURL/audios
    cd /local/repository/images
    for fname in $(ls .); do
        uuid=$(curl -H 'Content-Type: application/json' $COUCHDBURL/_uuids | awk -F\" '{print $4}')
        extension=$(echo $fname | awk -F. '{print $2}')
        curl -X PUT $COUCHDBURL/images/$uuid/$fname \
            --data-binary @$fname \
            -H 'Content-Type:image/'$extension
    done
    cd /local/repository/audios
    for fname in $(ls .); do
        uuid=$(curl -H 'Content-Type: application/json' $COUCHDBURL/_uuids | awk -F\" '{print $4}')
        extension=$(echo $fname | awk -F. '{print $2}')
        curl -X PUT $COUCHDBURL/images/$uuid/$fname \
            --data-binary @$fname \
            -H 'Content-Type:audio/'$extension
    done
fi