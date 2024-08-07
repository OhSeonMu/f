#!/bin/bash

# DIRECTORY_INFO
OUTPUT_PATH="$(pwd)/raw_data"
RESULT_PATH="$(pwd)/result"

# APP INFO 
APPS=(
	"XSBench" "bc" "bfs" "cc" "cc_sv" "converter" "pr" "pr_spmv" "sssp" "tc"
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
)

# FOR RUN_MLC
# RW ratio (1:1 2:1 3:1 3:2 4:1)
MODES=(5 2 3 4 12)
NODES=(0 1)

# FOR CAL_BANDWIDTH
TIME_BINS=(
	"200" "563" "419" "402" "496" "396" "506" "534" "415" "609"
)

APP_NUMBER=${#APPS[@]}
