#!/bin/bash

# Director Info
output_path="./raw_data"

# Core Info
CORES_0=(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25)
CORES_1=(26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51)
# CORES_0=($(numactl --hardware | grep "node 0 cpus:" | awk -F: '{print $2}'))
# CORES_1=($(numactl --hardware | grep "node 1 cpus:" | awk -F: '{print $2}'))

function disable_core()
{
	local PARAM=$1
	if [ ${PARAM} -eq 0 ]; then
		local disable_cores=("${CORES_0[@]}")
	else
		local disable_cores=("${CORES_1[@]}")
	fi
	for core in "${disable_cores[@]}"; do
		echo 0 | sudo tee "/sys/devices/system/cpu/cpu${core}/online"
	done
}

function enable_core()
{
	local PARAM=$1
	if [ ${PARAM} -eq 0 ]; then
		local disable_cores=("${CORES_0[@]}")
	else
		local disable_cores=("${CORES_1[@]}")
	fi
	for core in "${disable_cores[@]}"; do
		echo 1 | sudo tee "/sys/devices/system/cpu/cpu${core}/online"
	done
}

# Disable Remote Node Core
# disable_core 1
enable_core 1
