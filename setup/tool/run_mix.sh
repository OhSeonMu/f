#!/bin/bash

DIR=$(dirname "$(realpath "$0")")
cd ${DIR}

# benchmarks=("a" "b" "c" "d" "e") 
benchmarks=("$@") 
pids=() 

n=${#benchmarks[@]}

state_file=$(mktemp)

completed=()
for ((i=0; i<n; i++)); do
  echo 0 >> "$state_file"
done

CHILD_PIDS=()
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

run_benchmark() {
  local index=$1
  local name=${benchmarks[$index]}

  while true; do
    taskset -c ${index} ./run_speccpu.sh $name
    
    current_status=$(sed -n "$((index + 1))p" "$state_file")   
    if [ "$current_status" -eq 0 ]; then
	    sed -i "$((index + 1))s/0/1/" "$state_file"
      
      all_completed=true
      for ((j=0; j<n; j++)); do
	if [ "$(sed -n "$((j + 1))p" "$state_file")" -eq 0 ]; then
          all_completed=false
          break
        fi
      done
      
      if [ "$all_completed" = true ]; then
        echo "All benchmarks have been completed at least once."
	break
      fi
    fi
  done
}

for ((i=0; i<n; i++)); do
  run_benchmark $i &
  CHILD_PIDS+=("$!")
done

wait -n
cleanup
