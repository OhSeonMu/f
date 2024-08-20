#!/bin/bash

DIR=$(dirname "$(realpath "$0")")
cd ${DIR}
cd ../hmsdk

# Start HMSDK based on hmsdk.yaml
sudo ./damo/damo start hmsdk.yaml
