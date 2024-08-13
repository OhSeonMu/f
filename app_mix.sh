#!/bin/bash
source ./setup/config.sh

for MIX_INDEX in $(seq 0 $((${MIX_NUMBER} -1))); do
	MIX=${MIXS[${MIX_INDEX}]}
	MIX_PATH=${MIX_PATHS[${MIX_INDEX}]}
	echo "MIX is ${MIX}" 
	
	for INDEX in $(seq 0 $((${RATIO_NUMBER} - 1))); do
		LOCAL_RATIO=${LOCAL_RATIOS[${INDEX}]}
		REMOTE_RATIO=1
		echo "LOCAL_RATIO is ${LOCAL_RATIO}" 

		if [ ${LOCAL_RATIO} -eq 0 ] ; then
			${MIX_PATH} > ${OUTPUT_PATH}/${MIX}_default	
		elif [ ${LOCAL_RATIO} -eq 5 ] ; then
			${UTIL_PATH}/enable_hmsdk.sh
			${MIX_PATH} > ${OUTPUT_PATH}/${MIX}_tiering 	
			${UTIL_PATH}/disable_hmsdk.sh	
		else
			echo ${LOCAL_RATIO} > /sys/kernel/mm/mempolicy/weighted_interleave/node0
			echo ${REMOTE_RATIO} > /sys/kernel/mm/mempolicy/weighted_interleave/node1
			${NUMACTL_PATH}/numactl --weighted-interleave=0,1 ${MIX_PATH} > ${OUTPUT_PATH}/${MIX}_interleave_${LOCAL_RATIO}_${REMOTE_RATIO} 	
		fi
	done
done
