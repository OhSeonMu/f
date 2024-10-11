#!/bin/bash

DIR=$(dirname "$(realpath "$0")")
cd ${DIR}
cd ../../
source ./setup/config.sh

# IFS=' ' read -r -a benchmarks <<< "$1"
benchmarks=($1)
TYPE=$2
MIX=$3

indexs=()

n=${#benchmarks[@]}

state_file=$(mktemp)

completed=()
for ((i=0; i<n; i++)); do
  echo 0 >> "$state_file"
done

CHILD_PIDS=()
RUN_PIDS=()

get_child() {
    local parent_pid=$1
    CHILD_PIDS+=($parent_pid)

    local children=$(pgrep -P "$parent_pid")

    for child in $children; do
    	get_child $child
    done
}

kill_tree() {
  local pid=$1
  local child_pids=$(pgrep -P $pid 2>/dev/null)

  for child_pid in $child_pids; do
    kill_tree $child_pid
  done

  kill -9 $pid > /dev/null 2>&1
}

cleanup() {
  echo "Cleaning up..."
  for CHILD_PID in "${CHILD_PIDS[@]}"; do
    kill_tree ${CHILD_PID}
  done
  rm -f "$state_file" > /dev/null 2>&1
  echo "Delete all benchmark and file"
}

build_paths=()
build_benchmark() {
	local index=${1}
	local tmp_file=$(mktemp)
	local BUILD_PATH=${2}
	echo "Build Start : $BUILD_PATH"
	taskset -c $((${index}*4))-$((${index}*4+4)) ${BUILD_PATH} > $tmp_file &
	while true; do
		if grep -q "BUILD END" "$tmp_file"; then
			break
		fi
		sleep 10
	done
	echo "Build End : $BUILD_PATH"
	rm $tmp_file
}

run_benchmark() {
  local index=${1}
  local loop=true
  local APP=${APPS[${indexs[${1}]}]}
  local APP_PATH=${APP_PATHS[${indexs[${1}]}]}
  echo RUN : ${APP}

  while $loop; do
    local start_time=$(date +%s.%N)
    taskset -c $((${index}*4))-$((${index}*4+3)) ${APP_PATH} > /dev/null 2>&1
    local end_time=$(date +%s.%N)
    
    local current_status=$(sed -n "$((index + 1))p" "$state_file")   
    if [ "$current_status" -eq 0 ]; then
	    local elapsed_time=$(echo "$end_time - $start_time" | bc)
  	    echo END : ${APP}
	    echo "${APP},${elapsed_time}" >> ${RESULT_PATH}/${TYPE}_${MIX}_runtime.csv
	    sed -i "$((index + 1))s/0/1/" "$state_file"
    fi
      
    local all_completed=true
    for ((j=0; j<n; j++)); do
	if [ "$(sed -n "$((j + 1))p" "$state_file")" -eq 0 ]; then
		all_completed=false
          	break
        fi
    done
      
    if [ "$all_completed" = true ]; then
	echo "${APP} : All benchmarks have been completed at least once."
	loop=false
    fi
  done
}

rm ${RESULT_PATH}/${TYPE}_${MIX}_runtime.csv
echo "app,runtime(s)" >> ${RESULT_PATH}/${TYPE}_${MIX}_runtime.csv

# Build And Find Index
for ((i=0; i<n; i++)); do
  for ((index=0; index < ${#APPS[@]}; index++)); do
	if [[ ${APPS[${index}]} == ${benchmarks[${i}]} ]]; then
		indexs+=($index)
		if [[ ${BUILD_PATHS[${index}]} != "0" ]]; then	
			# echo "Build Setup : ${BUILD_PATHS[${index}]}" 
			build_benchmark $i "${BUILD_PATHS[${index}]}" &
			build_pid=$!
			sleep 1
			get_child $build_pid
		fi
	fi	
  done
done
wait

# For Check Bandwidth 
#${TOOL_PATH}/print_bandwidth.sh > ${RESULT_PATH}/${TYPE}_${MIX}_total_bandwidth.csv &
${TOOL_PATH}/print_bandwidth.sh ${RESULT_PATH}/${TYPE}_${MIX}_total_bandwidth.csv &

echo run
# Run 
for ((i=0; i<n; i++)); do
  # echo "Run Setup : ${APP_PATHS[${indexs[${i}]}]}"
  run_benchmark $i &
  run_pid=$!
  CHILD_PIDS+=($run_pid)
  RUN_PIDS+=($run_pid)
done

while true; do
    for pid in "${RUN_PIDS[@]}"; do
    	if ! kill -0 "$pid" 2>/dev/null; then
		# For Check Bandwidth 
		# pkill -f perf
		pgrep pcm | xargs kill -9
		sed -i '1d' "${RESULT_PATH}/${TYPE}_${MIX}_total_bandwidth.csv"
		cleanup
		exit 0
	fi
    done
    sleep 1
done
