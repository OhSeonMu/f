#!/bin/bash

DIR=$(dirname "$(realpath "$0")")
cd ${DIR}
cd ../hmsdk

# Stop HMSDK based on hmsdk.yaml.
sudo ../hmsdk/damo/damo stop
