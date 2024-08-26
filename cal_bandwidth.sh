#!/bin/bash
source ./setup/config.sh

for INDEX in $(seq 0 $((${APP_NUMBER} - 1))); do
	APP=${APPS[${INDEX}]}
	APP_PATH=${APP_PATHS[${INDEX}]}
	# TIME_BIN=${TIME_BINS[${INDEX}]}
	rm ${OUTPUT_PATH}/${APP}
	rm -rf ${OUTPUT_PATH}/${APP}_bandwidth 
	rm ${RESULT_PATH}/${APP}_bandwidth.csv

	/opt/intel/oneapi/vtune/2024.2/bin64/vtune -collect memory-access -result-dir ${OUTPUT_PATH}/${APP}_bandwidth -- ${APP_PATH} > ${OUTPUT_PATH}/${APP}
	# /opt/intel/oneapi/vtune/2024.2/bin64/vtune -report timeline -result-dir ${OUTPUT_PATH}/${APP}_bandwidth -report-knob column-by=OvertimeBandwidth -report-knob bin-count=${TIME_BIN} -format=csv -csv-delimiter=comma > ${RESULT_PATH}/${APP}_bandwidth.csv
	/opt/intel/oneapi/vtune/2024.2/bin64/vtune -report timeline -result-dir ${OUTPUT_PATH}/${APP}_bandwidth -report-knob column-by=OvertimeBandwidth -report-knob bin-count=30 -format=csv -csv-delimiter=comma > ${RESULT_PATH}/${APP}_bandwidth.csv
done
