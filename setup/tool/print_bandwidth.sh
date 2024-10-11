#!/bin/bash

DIR=$(dirname "$(realpath "$0")")  
cd ${DIR}
cd ../../
source ./setup/config.sh

# 원본 CSV 파일 경로 (변경할 파일)
input_file=$1
./setup/pcm/build/bin/pcm-memory 1 -nc -csv=$input_file
