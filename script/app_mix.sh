#!/bin/bash
cd ../
source ./setup/config.sh

for INDEX in $(seq 0 $((${RATIO_NUMBER} - 1))); do
	LOCAL_RATIO=${LOCAL_RATIOS[${INDEX}]}
	REMOTE_RATIO=1
	for MIX_INDEX in $(seq 0 $((${MIX_NUMBER} -1))); do
		MIX=${MIXS[${MIX_INDEX}]}
		MIX_PATH=${MIX_PATHS[${MIX_INDEX}]}
		echo "LOCAL_RATIO is ${LOCAL_RATIO}" 
		echo "MIX is ${MIX}" 
		echo "${TOOL_PATH}/run_mix.sh '${MIX_PATH}' ${LOCAL_RATIO} ${MIX}"

		# For Check Bandwidth
		# ${TOOL_PATH}/print_bandwidth.sh > ${RESULT_PATH}/total_bandwidth_${MIX}_${LOCAL_RATIO}.csv &
		
		if [ ${LOCAL_RATIO} -eq 0 ] ; then
			${TOOL_PATH}/run_mix.sh "${MIX_PATH}" ${LOCAL_RATIO} ${MIX}
		elif [ ${LOCAL_RATIO} -eq 5 ] ; then
			${UTIL_PATH}/enable_hmsdk.sh
			${TOOL_PATH}/run_mix.sh "${MIX_PATH}" ${LOCAL_RATIO} ${MIX}
			${UTIL_PATH}/disable_hmsdk.sh	
		else
			echo ${LOCAL_RATIO} > /sys/kernel/mm/mempolicy/weighted_interleave/node0
			echo ${REMOTE_RATIO} > /sys/kernel/mm/mempolicy/weighted_interleave/node1
			${NUMACTL_PATH}/numactl --weighted-interleave=0,1 ${TOOL_PATH}/run_mix.sh "${MIX_PATH}" ${LOCAL_RATIO} ${MIX}
		fi
		
		# For Check Bandwidth
		# pkill -f perf
	done
done
