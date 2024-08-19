#!/bin/bash

#################################
#	For Run MLC		#
#################################

:<<"END"
./run_mlc.sh

cd graph_script
python3 ./graph_script/result_mlc.py
cd ../
END

#################################
#	For Cal Bandwidth	#
#################################

:<<"END"
./cal_bandwidth.sh

cd graph_script
python3 ./app_bandwidth.py
cd ../
END

