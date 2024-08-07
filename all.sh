#!/bin/bash

#################################
#	For Run Script		#
#################################

:<<"END"
# For run_mlc.sh
./run_mlc.sh
END

# For cal_bandwidth.sh
./cal_bandwidth.sh

#################################
#	For Graph Script	#
#################################

cd graph_script

:<<"END"
# For run_mlc.sh
python3 result_mlc.py
END

# For cal_bandwidth.sh
python3 app_bandwidth.py

