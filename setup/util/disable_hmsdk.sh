#!/bin/bash

DIR=$(dirname "$(realpath "$0")")
cd ${DIR}
cd ../hmsdk

# Stop HMSDK based on hmsdk.yaml.
sudo ./damo/damo stop
