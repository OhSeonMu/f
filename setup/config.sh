#!/bin/bash

# DIRECTORY_INFO
OUTPUT_PATH="$(pwd)/raw_data"
RESULT_PATH="$(pwd)/result"

# PATH
NUMACTL_PATH=$(pwd)/setup/hmsdk/numactl
UTIL_PATH=$(pwd)/setup/util
TOOL_PATH=$(pwd)/setup/tool

#########################################
#	    For run_mlc.sh		#
#########################################
# RW ratio (1:1 2:1 3:1 3:2 4:1)
MODES=(5 2 3 4 12)
NODES=(0 1)

#########################################
#	For cal_bandwidth.sh		#
#########################################
:<<"END"
APPS=(
	cdn_high
	cdn_low
)

APP_PATHS=(
	"$(pwd)/app/CacheLib/opt/cachelib/bin/cachebench -json_test_config $(pwd)/app/CacheLib/opt/cachelib/test_configs/hit_ratio/cdn/config.json" 
	"$(pwd)/app/CacheLib/opt/cachelib/bin/cachebench -json_test_config $(pwd)/app/CacheLib/opt/cachelib/test_configs/hit_ratio/cdn/config_qps.json"
)

APP_NUMBER=${#APPS[@]}
END

APPS=(
	# 600
	# bc
	XSBench
)

APP_PATHS=(
	# "${TOOL_PATH}/run_speccpu.sh 600"
	# "$(pwd)/app/gapbs/client 1 100 127.0.0.1 22"
	"$(pwd)/app/XSBench/openmp-threading/client 1 127.0.0.1 22" 
)

BUILD_PATHS=(
	# "0"
	# "$(pwd)/app/gapbs/bc -g 20 -S -p 22"
	"$(pwd)/app/XSBench/openmp-threading/XSBench -s large -t 4 -l 30"
)

APP_NUMBER=${#APPS[@]}

#########################################
#	    For app_mlx.sh		#
#########################################
# LOCAL_RATIOS=(0 1 2 3 4 5)
LOCAL_RATIOS=(0) # 1 5)

MIXS=(
	"mix_1" 
)

MIX_PATHS=(
	"603 605 621"
)

RATIO_NUMBER=${#LOCAL_RATIOS[@]}
MIX_NUMBER=${#MIXS[@]}

