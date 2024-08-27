#!/bin/bash

PID=$1
APPLICATION=$2

echo "APP,VSZ(GB),RSS(GB)"
while true; do
  ps -o vsz,rss -p $PID | awk -v APP=${APPLICATION} 'NR>1 {printf "%s,%.2f,%.2f\n", APP, $1/1024/1024, $2/1024/1024}'
  sleep 1
done
