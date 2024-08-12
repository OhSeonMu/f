#!/bin/bash
source ./setup/config.sh

for INDEX in $(seq 0 $((${RATIO_NUMBER} - 1))); do
	LOCAL_RATIO=${LOCAL_RATIOS[${INDEX}]}
	REMOTE_RATIO=1
	
	for MIX_PATH in ${MIX_PATH}; do
		if [ LOCAT_RATIO -eq 5 ] ; then
			${UTIL_PATH}/enable_hmsdk.sh
			${MIX_PATH}	
			${UTIL_PATH}/disable_hmsdk.sh	
		else
			echo ${LOCAL_RATIO} > /sys/kernel/mm/mempolicy/weighted_interleave/node0
			echo ${REMOTE_RATIO} > /sys/kernel/mm/mempolicy/weighted_interleave/node1
			numactl --weighted-interleave=0,1 ${MIX_PATH}
		fi
	done
done
