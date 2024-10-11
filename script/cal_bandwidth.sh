#!/bin/bash
cd ../
source ./setup/config.sh

APP_NUMBER=${#ANALYSIS_APPS[@]}
for INDEX in $(seq 0 $((${APP_NUMBER} - 1))); do
	APP=${ANALYSIS_APPS[${INDEX}]}
	for (( i=0; i < ${#APPS[@]}; i++ )); do
		if [[ $APP == ${APPS[$1]} ]]; then
			TMP_INDEX=$1
		fi
	done
	APP_PATH=${APP_PATHS[${TMP_INDEX}]}
	BUILD_PATH=${BUILD_PATHS[${TMP_INDEX}]}

	rm ${OUTPUT_PATH}/${APP}
	rm -rf ${OUTPUT_PATH}/${APP}_bandwidth 
	rm ${RESULT_PATH}/${APP}_bandwidth.csv
	# For memory footprint
	rm ${OUTPUT_PATH}/${APP}_footprint.csv 

	echo ${APP}
	if [ "${BUILD_PATH}" != "0" ]; then
		${BUILD_PATH} > ${OUTPUT_PATH}/${APP} &
		BUILD_PID=$!
		
		while true; do
			echo ${APP}
			if grep -q "BUILD END" "${OUTPUT_PATH}/${APP}"; then  
				break
			fi
			sleep 5
		done
		${APP_PATH} & 
		APP_PID=$!
		RUN_PID=$BUILD_PID
	else
		${APP_PATH} > ${OUTPUT_PATH}/${APP} &
		APP_PID=$!
		RUN_PID=$APP_PID
	fi
	echo ${APP}
	echo ${APP_PID}
	
	# For memory bandwidth
	/opt/intel/oneapi/vtune/2024.2/bin64/vtune -collect memory-access -result-dir ${OUTPUT_PATH}/${APP}_bandwidth -target-pid ${RUN_PID} &
	TOOL_BANDWIDTH_PID=$!
	
	# For memory footprint
	${TOOL_PATH}/print_footprint.sh ${RUN_PID} ${APP} >> ${OUTPUT_PATH}/${APP}_footprint.csv &  
	TOOL_FOOTPRINT_PID=$!
	wait ${APP_PID} 
	if [ "${BUILD_PATH}" != "0" ]; then
		kill -9 ${BUILD_PID}
	fi
	kill -9 ${TOOL_FOOTPRINT_PID}

	# For memory bandwidth
	wait ${TOOL_BANDWIDTH_PID}
	/opt/intel/oneapi/vtune/2024.2/bin64/vtune -report timeline -result-dir ${OUTPUT_PATH}/${APP}_bandwidth -report-knob column-by=OvertimeBandwidth -report-knob bin-count=30 -format=csv -csv-delimiter=comma > ${RESULT_PATH}/${APP}_bandwidth.csv
	
	rm -rf ${OUTPUT_PATH}/${APP}_bandwidth 
done
