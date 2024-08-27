#!/bin/bash
cd ../

#################################
#      For System Analysis	#
#################################
:<<"END"
cd ./script
./run_mlc.sh
cd ../

cd ./graph_script
python3 ./result_mlc.py
cd ../
END

#################################
#	For Cal Bandwidth	#
#################################
:<<"END"
cd ./script
./cal_bandwidth.sh
cd ../

cd ./graph_script
python3 ./app_bandwidth.py
cd ../
END

#################################
#	For App Analysis	#
#################################
cd ./script
./cal_bandwidth.sh
cd ../

cd ./graph_script
python3 ./app_analysis.py
cd ../
