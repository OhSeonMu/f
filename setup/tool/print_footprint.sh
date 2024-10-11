#!/bin/bash

PID=$1
APPLICATION=$2

echo "APP,VSZ(GB),RSS(GB)"
while true; do
  pids=$(pstree -p ${PID} | grep -oP '\(\d+\)' | grep -oP '\d+')
  total_vsz=0
  total_rss=0
  for pid in $pids; do
    mem=$(ps -o vsz,rss -p $pid --no-headers)
    vsz=$(echo $mem | awk '{print $1}')
    rss=$(echo $mem | awk '{print $2}')
    total_vsz=$((total_vsz + vsz))
    total_rss=$((total_rss + rss))
  done
  vsz_mb=$(echo "scale=2; $total_vsz/1024/1024" | bc)
  rss_mb=$(echo "scale=2; $total_rss/1024/1024" | bc)

  printf "%s,%0.2f,%0.2f\n" "${APPLICATION}" "${vsz_mb}" "${rss_mb}"
  sleep 1
done
