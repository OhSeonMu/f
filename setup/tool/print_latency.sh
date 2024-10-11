#!/bin/bash

DIR=$(dirname "$(realpath "$0")")  
cd ${DIR}
cd ../../
source ./setup/config.sh

./setup/pcm/build/bin/pcm-latency -slient | grep -A 2 "DDR read Latency"
