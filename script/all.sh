#!/bin/bash
cd ../
 
#################################
#      For System Analysis	#
#################################
# Measure Local/Remote latency per bandwidth
:<<"END"
cd ./script
./run_mlc.sh
cd ../

cd ./graph_script
python3 ./result_mlc.py
cd ../
END

#################################
#      For System Analysis	#
#################################
# Measure Local/Remote latency per bandwidth by varying # of channel/memory module
:<<"END"
capacity=16
num=$1

cd ./script
./run_mlc.sh
cd ../

cd ./graph_script
python3 ./result_mlc.py
cd ../

cd ./result
mkdir system
mv mlc_local.csv ./system/local_${capacity}_${num}_${capacity}_${num}.csv
mv mlc_remote.csv ./system/remote_${capacity}_${num}_${capacity}_${num}.csv
cd ../

cd ./graph
mkdir system
mv mlc_local.png ./system/local_${capacity}_${num}_${capacity}_${num}.png
mv mlc_remote.png ./system/remote_${capacity}_${num}_${capacity}_${num}.png
cd ../

cd ./graph_script
python3 ./result_mlc_consol.py
cd ../
END

#################################
#	For App Analysis	#
#################################
# Measure App bandwidth and memory footprint
:<<"END"
cd ./script
./cal_bandwidth.sh
cd ../

cd ./graph_script
python3 ./app_analysis.py
cd ..
END

#################################
#	For User Request	#
#################################
:<<"END"
cd ./script
./user_request.sh
cd ../

cd ./graph_script
python3 ./app_bandwidth.py
cd ..
END

#################################
#	For User Request	#
#################################
cd ./script
./app_mix.sh
cd ../

cd ./graph_script
python3 ./app_mix_stack.py
python3 ./app_mix_bandwidth.py
cd ..

