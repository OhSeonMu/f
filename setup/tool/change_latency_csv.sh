#!/bin/bash

# CSV 파일 초기화
output_file="./latency_data.csv"
echo "time(s),local_latency(ns),remote_latency(ns)" > $output_file

# 입력 파일
input_file="./tmp"

# 시간 초기화
time=1

# 파일 처리
while IFS= read -r line
do
    # Socket0 값 추출
    if [[ $line == Socket0:* ]]; then
	    local_latency=$(echo $line | awk -F': ' '{print $2}')
	    # Socket1 값 추출
    elif [[ $line == Socket1:* ]]; then
	    remote_latency=$(echo $line | awk -F': ' '{print $2}')
	    # CSV 파일에 시간, local_latency, remote_latency 기록
	    echo "$time,$local_latency,$remote_latency" >> $output_file
	    # 시간 증가
	    ((time++))
    fi
done < "$input_file"

echo "CSV 파일 변환 완료!"

