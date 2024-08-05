#!/bin/bash

# DIRECTORY_INFO
OUTPUT_PATH="$(pwd)/raw_data"
RESULT_PATH="$(pwd)/result"

# APP INFO 
APP_NUMBER=1
APPS=("XSBench")
APP_PATHS=("$(pwd)/app/XSBench/openmp-threading/XSBench -s XL -l 150")

# FOR RUN_MLC
# RW ratio (1:1 2:1 3:1 3:2 4:1)
MODES=(5 2 3 4 12)
NODES=(0 1)

# FOR CAL_BANDWIDTH
TIME_BINS=("200")


