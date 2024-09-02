#!/bin/bash
cd ../
source ./setup/config.sh

for INDEX in $(seq 0 $((${APP_NUMBER} - 1))); do
	APP=${APPS[${INDEX}]}
	APP_PATH=${APP_PATHS[${INDEX}]}
	BUILD_PATH=${BUILD_PATHS[${INDEX}]}

	rm ${OUTPUT_PATH}/${APP}
	rm -rf ${OUTPUT_PATH}/${APP}_bandwidth 
	rm ${RESULT_PATH}/${APP}_bandwidth.csv
	# For memory footprint
	rm ${OUTPUT_PATH}/${APP}_footprint.csv 

	echo ${APP}
	if [ "${BUILD_PATH}" != "0" ]; then
		${BUILD_PATH} > ${OUTPUT_PATH}/${APP} &
		APP_PID=$!
		
		STATE_FILE=$(mktemp)
		while true; do
			${APP_PATH} > ${STATE_FILE}
			if grep -q "SUCCESS" "${STATE_FILE}"; then
				rm ${STATE_FILE}
				break
			fi
			sleep 5
		done
	else
		${APP_PATH} > ${OUTPUT_PATH}/${APP} &
		APP_PID=$!
	fi
	echo ${APP_PID}

	
	# For memory bandwidth
	/opt/intel/oneapi/vtune/2024.2/bin64/vtune -collect memory-access -result-dir ${OUTPUT_PATH}/${APP}_bandwidth -target-pid ${APP_PID} &
	TOOL_BANDWIDTH_PID=$!
	
	# For memory footprint
	${TOOL_PATH}/print_footprint.sh ${APP_PID} ${APP} >> ${OUTPUT_PATH}/${APP}_footprint.csv &  
	TOOL_FOOTPRINT_PID=$!
	wait ${APP_PID} 
	kill -9 ${TOOL_FOOTPRINT_PID}
	
	# For memory bandwidth
	wait ${TOOL_BANDWIDTH_PID}
	/opt/intel/oneapi/vtune/2024.2/bin64/vtune -report timeline -result-dir ${OUTPUT_PATH}/${APP}_bandwidth -report-knob column-by=OvertimeBandwidth -report-knob bin-count=30 -format=csv -csv-delimiter=comma > ${RESULT_PATH}/${APP}_bandwidth.csv
done
