#!/bin/bash

DIR=$(dirname "$(realpath "$0")")  
cd ${DIR}
cd ../../
source ./setup/config.sh

# Make CSV
make_csv() {
	local pid=$1
	if [ -z $pid ]; then
		perf_output_file="${RESULT_PATH}/perf_output.txt"
	else
		perf_output_file="${RESULT_PATH}/perf_output_${pid}.txt"
	fi
	
	grep -E "mem_load_l3_miss_retired.local_dram|mem_load_l3_miss_retired.remote_dram" ${perf_output_file} | while read -r line
	do
		time=$(echo $line | awk '{print $1}')
		
		bandwidth=$(echo $line | awk '{print $2}')
		bandwidth=$(echo $bandwidth | tr -d ',')
		if [ "$bandwidth" -eq "$bandwidth" ] 2>/dev/null; then
			bandwidth=$(($bandwidth * 64 / (1024*1024*1024)))
		else
			bandwidth=0
		fi

		event=$(echo $line | awk '{print $3}')
		if [ $event = "mem_load_l3_miss_retired.local_dram" ]; then
			event="local"
		else
			event="remote"
		fi	
		echo "$time,$bandwidth,$pid,$event"
	done
}

# Get argument 
if [ "$#" -ne 0 ]; then
	PIDS=( "$@" )
fi

# Run Perf 
if [ "${#PIDS[@]}" -eq 0 ]; then
	perf stat -e "mem_load_l3_miss_retired.local_dram, mem_load_l3_miss_retired.remote_dram" -I 1000 2> ${RESULT_PATH}/perf_output.txt &
else
	for pid in "${PIDS[@]}"; do
		perf stat -e "mem_load_l3_miss_retired.local_dram, mem_load_l3_miss_retired.remote_dram" -I 1000 -p ${pid} 2> ${RESULT_PATH}/perf_output_${pid}.txt &
	done
fi

wait 

# Make CSV
echo "time(s),bandwidth(GB/s),pid,event"
if [ "${#PIDS[@]}" -eq 0 ]; then
	make_csv
	rm ${RESULT_PATH}/perf_output.txt
else
	for pid in "${PIDS[@]}"; do
		make_csv $pid
		rm ${RESULT_PATH}/perf_output_${pid}.txt
	done
fi
