#!/bin/bash
source ./setup/config.sh

# RW ratio (1:1 2:1 3:1 3:2 4:1)
# MODES=(5 2 3 4 12)

# Node
# NODES=(0 1)

for node in "${NODES[@]}"; do
	if [ ${node} -eq 0 ]; then
		cpus="1-9"
	else
		cpus="11-19"
	fi

	# R:W=1:0
	./app/mlc/Linux/mlc --loaded_latency -c0 -i0 -j${node} -k${cpus} -R > ${OUTPUT_PATH}/mlc_node${node}_mode0
	# R:W=M:N
	for mode in "${MODES[@]}"; do 
		./app/mlc/Linux/mlc --loaded_latency -c0 -i0 -j${node} -k${cpus} -W${mode} > ${OUTPUT_PATH}/mlc_node${node}_mode${mode}
	done
done
