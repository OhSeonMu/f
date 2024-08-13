#!/bin/bash

DIR=$(dirname "$(realpath "$0")")
cd ${DIR}
cd ../hmsdk

# Start HMSDK based on hmsdk.yaml
sudo ../hmsdk/damo/damo start hmsdk.yaml
