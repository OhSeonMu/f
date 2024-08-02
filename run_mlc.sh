#!/bin/bash

# Directory Info
output_path="./raw_data"

# Core Info
CORES_0=(0 1 2 3 4 5 6 7 8 9)
CORES_1=(10 11 12 13 14 15 16 17 18 19)

# RW ratio (1:1 2:1 3:1 3:2 4:1)
MODES=(5 2 3 4 12)

# Node
NODES=(0 1)

for node in "${NODES[@]}"; do
	if [ ${node} -eq 0 ]; then
		cpus="1-9"
	else
		cpus="11-19"
	fi

	# R:W=1:0
	./app/mlc/Linux/mlc --loaded_latency -c0 -i0 -j${node} -k${cpus} -R > ${output_path}/mlc_node${node}_mode0
	# R:W=M:N
	for mode in "${MODES[@]}"; do 
		./app/mlc/Linux/mlc --loaded_latency -c0 -i0 -j${node} -k${cpus} -W${mode} > ${output_path}/mlc_node${node}_mode${mode}
	done
done
