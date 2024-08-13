#!/bin/bash

# DIRECTORY_INFO
OUTPUT_PATH="$(pwd)/raw_data"
RESULT_PATH="$(pwd)/result"

# NUMCATL PATH
NUMACTL_PATH=$(pwd)/setup/hmsdk/numactl

# UTIL PATH
UTIL_PATH=$(pwd)/setup/util

:<<"END"
#########################################
#	    For run_mlc.sh		#
#########################################
# RW ratio (1:1 2:1 3:1 3:2 4:1)
MODES=(5 2 3 4 12)
NODES=(0 1)

#########################################
#	For cal_bandwidth.sh		#
#########################################
APPS=(
	# "XSBench" "bc" "bfs" "cc" "cc_sv" "converter" "pr" "pr_spmv" "sssp" "tc" "cdn"
)

APP_PATHS=(
	"$(pwd)/app/XSBench/openmp-threading/XSBench -s XL -l 150"
	# gapbs에서 -i option 도 사용할 수 있다. 
	"$(pwd)/app/gapbs/bc -g 28 -n 1"
	"$(pwd)/app/gapbs/bfs -g 28 -n 1"
	"$(pwd)/app/gapbs/cc -g 28 -n 2"
	"$(pwd)/app/gapbs/cc_sv -g 28 -n 2"
	"$(pwd)/app/gapbs/converter -g 28 -n 2"
	"$(pwd)/app/gapbs/pr -g 28 -n 2"
	"$(pwd)/app/gapbs/pr_spmv -g 28 -n 2"
	"$(pwd)/app/gapbs/sssp -g 28 -n 2"
	"$(pwd)/app/gapbs/tc -g 28 -n 2"
	"$(pwd)/app/CacheLib/opt/cachelib/bin/cachebench -json_test_config $(pwd)/app/CacheLib/opt/cachelib/test_configs/hit_ratio/cdn/config.json"
)

TIME_BINS=(
	"200" "563" "419" "402" "496" "396" "506" "534" "415" "609" "30"
)

APP_NUMBER=${#APPS[@]}
END

#########################################
#	    For app_mlx.sh		#
#########################################
# LOCAL_RATIOS=(1 2 3 4 5)
LOCAL_RATIOS=(0 5)

MIXS=(
	"mix_1"
)

MIX_PATHS=(
	"$(pwd)/app/XSBench/openmp-threading/XSBench -s XL -l 100"
)

RATIO_NUMBER=${#LOCAL_RATIOS[@]}
MIX_NUMBER=${#MIXS[@]}

