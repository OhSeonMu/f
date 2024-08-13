#!/bin/bash


DIR=$(dirname "$(realpath "$0")")
cd ${DIR}
cd ../hmsdk
# The -d/--demote and -p/--promote options can be used multiple times.
# The SRC and DEST are migration source node id and destination node id.
# sudo ./tools/gen_config.py -d SRC DST -p SRC DST -o hmsdk.yaml
sudo ./tools/gen_config.py -d 0 1 -p 1 0 -o hmsdk.yaml

# Enable demotion to slow tier. This prevents from swapping out from fast tier.
echo true | sudo tee /sys/kernel/mm/numa/demotion_enabled

# make sure cgroup2 is mounted under /sys/fs/cgroup, then create "hmsdk" directory below. 
sudo mount -t cgroup2 none /sys/fs/cgroup
echo '+memory' | sudo tee /sys/fs/cgroup/cgroup.subtree_control
sudo mkdir -p /sys/fs/cgroup/hmsdk
