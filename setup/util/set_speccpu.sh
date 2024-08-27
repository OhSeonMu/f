#!/bin/bash
DIR=$(dirname "$(realpath "$0")")

cd ${DIR}/../../app/speccpu_2017
source shrc
DIR=$(dirname "$(realpath "$0")")

# Use peak instead of peak (no reason) 
# clean
# runcpu --config config.cfg --loose --action clean --tune base all
runcpu --config config.cfg --loose --action clean

# build
# ref
runcpu --config config.cfg --loose --action build --threads 4 --tune base all
# test
runcpu --config config.cfg --loose --action build --threads 4 --tune base --size test all

# setup
# ref
runcpu --config config.cfg --loose --action runsetup --threads 4 --tune base all
# test
runcpu --config config.cfg --loose --action runsetup --threads 4 --tune base --size test all

# run
:<<"END"
cd ./benchspec/cpu/${BENCH_NAME}/${DIR_NAME}
specinvoke
END
