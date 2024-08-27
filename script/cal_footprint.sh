#!/bin/bash
cd ../
source ./setup/config.sh

for INDEX in $(seq 0 $((${APP_NUMBER} - 1))); do
	APP=${APPS[${INDEX}]}
	APP_PATH=${APP_PATHS[${INDEX}]}
	rm ${OUTPUT_PATH}/${APP}_footprint.csv

	${APP_PATH} &
	APP_PID=$!
	${TOOL_PATH}/print_footprint.sh $! ${APP} >> ${OUTPUT_PATH}/${APP}_footprint.csv &
	TOOL_PID=$!
	wait ${APP_PID}
	kill -9 ${TOOL_PID}
done
