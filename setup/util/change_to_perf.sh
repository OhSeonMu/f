#!/bin/bash
NCPU=`nproc`
for ((i = 0; i < $NCPU; i = i + 1))
do
    cpufreq-set -c $i -g performance
    #cpufreq-set -c $i -g powersave
    #cpufreq-set -c $i -g ondemand
    #cpufreq-set -c $i -g userspace
done
#for ((i = 0; i < 20; i = i + 1))
#do
#    cpufreq-set -c $i -f 3.1GHz
#done
