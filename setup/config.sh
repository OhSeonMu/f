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
	XSBench_xl bc_28 bfs_28 cc_28 cc_sv_28 converter_28 pr_28 pr_spmv_28 sssp_28 tc_28 cdn 600 605 620 623 625 631 641 648 657 603 607 619 621 628 638 644 649
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
	"$(pwd)/setup/tool/run_speccpu.sh 600"
	"$(pwd)/setup/tool/run_speccpu.sh 605"
	"$(pwd)/setup/tool/run_speccpu.sh 620"
	"$(pwd)/setup/tool/run_speccpu.sh 623"
	"$(pwd)/setup/tool/run_speccpu.sh 625"
	"$(pwd)/setup/tool/run_speccpu.sh 631"
	"$(pwd)/setup/tool/run_speccpu.sh 641"
	"$(pwd)/setup/tool/run_speccpu.sh 648"
	"$(pwd)/setup/tool/run_speccpu.sh 657"
	"$(pwd)/setup/tool/run_speccpu.sh 603"
	"$(pwd)/setup/tool/run_speccpu.sh 607"
	"$(pwd)/setup/tool/run_speccpu.sh 619"
	"$(pwd)/setup/tool/run_speccpu.sh 621"
	"$(pwd)/setup/tool/run_speccpu.sh 628"
	"$(pwd)/setup/tool/run_speccpu.sh 638"
	"$(pwd)/setup/tool/run_speccpu.sh 644"
	"$(pwd)/setup/tool/run_speccpu.sh 649"
)

APP_NUMBER=${#APPS[@]}

TIME_BINS=(
	# "200" "563" "419" "402" "496" "396" "506" "534" "415" "609" "30"
)
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
	# "mix_2" "mix_3" "mix_4" "mix_5" "mix_6"
)

MIX_PATHS=(
	"603 605 621"
	"607 619 600 621 628 638 649 657 631"
	"619 631 621 607 648 657 623 638 649"
	"641 657 623 605 648 625 631 619 638"
	"631 644 648 619 638 600 625 623 657"
	"621 638 657 649 644 628 607 600 619"
	"625 641 621 600 638 649 628 657 607"
)

RATIO_NUMBER=${#LOCAL_RATIOS[@]}
MIX_NUMBER=${#MIXS[@]}

