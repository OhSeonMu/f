#!/bin/bash

# cgroup v2: enable nesting 
if [ -f /sys/fs/cgroup/unified/cgroup.controllers ]; then 
	# move the processes from the root group to the /init group, 
	# otherwise writing subtree_control fails with EBUSY. 
	# An error during moving non-existent process (i.e., "cat") is ignored. 
	mkdir -p /sys/fs/cgroup/unified/init 
	xargs -rn1 < /sys/fs/cgroup/unified/cgroup.procs > /sys/fs/cgroup/unified/init/cgroup.procs || : 
	# enable controllers 
	sed -e 's/ / +/g' -e 's/^/+/' < /sys/fs/cgroup/unified/cgroup.controllers \ > /sys/fs/cgroup/unified/init/cgroup.subtree_control 
fi 
