#!/bin/bash

# add cpu cgroup firecracker
sudo mount -o remount,ro -t cgroup /sys/fs/cgroup
sudo mkdir /sys/fs/cgroup/cpu/firecracker
