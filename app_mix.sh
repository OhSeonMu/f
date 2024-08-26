#!/bin/bash
source ./setup/config.sh

function calculate_time()
{
	local RUN=$1
	# MIX NAME
	local NAME=$2
	# Interleave, tiering, default
	local TYPE=$3

	start_time=$(date +%s)
	${RUN}
	end_time=$(date +%s)
	elapsed_time=$((end_time - start_time))
	echo "${NAME},${TYPE},${elapsed_time}" >> ./raw_data/mix.csv
}

rm ./raw_data/mix.csv
echo "mix_name,type,run_time(s)" >> ./raw_data/mix.csv

for MIX_INDEX in $(seq 0 $((${MIX_NUMBER} -1))); do
	MIX=${MIXS[${MIX_INDEX}]}
	MIX_PATH=${MIX_PATHS[${MIX_INDEX}]}
	echo "MIX is ${MIX}" 
	
	for INDEX in $(seq 0 $((${RATIO_NUMBER} - 1))); do
		LOCAL_RATIO=${LOCAL_RATIOS[${INDEX}]}
		REMOTE_RATIO=1
		echo "LOCAL_RATIO is ${LOCAL_RATIO}" 

		if [ ${LOCAL_RATIO} -eq 0 ] ; then
			calculate_time "${TOOL_PATH}/run_mix.sh ${MIX_PATH}" "${MIX}" "default"
		elif [ ${LOCAL_RATIO} -eq 5 ] ; then
			${UTIL_PATH}/enable_hmsdk.sh
			calculate_time "${TOOL_PATH}/run_mix.sh ${MIX_PATH}" "${MIX}" "tiering"
			${UTIL_PATH}/disable_hmsdk.sh	
		else
			echo ${LOCAL_RATIO} > /sys/kernel/mm/mempolicy/weighted_interleave/node0
			echo ${REMOTE_RATIO} > /sys/kernel/mm/mempolicy/weighted_interleave/node1
			calculate_time "${NUMACTL_PATH}/numactl --weighted-interleave=0,1 ${TOOL_PATH}/run_mix.sh ${MIX_PATH}" "${MIX}" "interleave_${LOCAL_RATIO}_${REMOTE_RATIO}" 
		fi
	done
done
