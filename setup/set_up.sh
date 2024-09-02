#!/bin/bash

cd ./util
./change_to_perf.sh
./cstate_disable.sh
./disable_core.sh
./set_hmsdk.sh
./set_openmp.sh
./disable_memcached.sh
./dieable_redis.sh
