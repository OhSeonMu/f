#!/bin/bash

# Director Info
output_path="./raw_data"

# Core Info
CORES_0=(0 1 2 3 4 5 6 7 8 9)
CORES_1=(10 11 12 13 14 15 16 17 18 19)

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
disable_core 1
