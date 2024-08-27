#!/bin/bash
INPUT=$1
DIR=$(dirname "$(realpath "$0")")

ERROR=(502 602 654 627)
SPECRATE=(500 505 520 523 525 531 541 548 557 503 507 508 510 511 519 521 526 527 538 544 549 554)
SPECSPEED=(600 605 620 623 625 631 641 648 657 603 607 619 621 628 638 644 649)

cd ${DIR}/../../app/speccpu_2017
source shrc

for number in ${ERROR[@]} 
do
	if [ $number -eq $INPUT ]; then
		check=1
	        exit	
	fi
done

check=0
for number in ${SPECRATE[@]} 
do
	if [ $number -eq $INPUT ]; then
		check=1
	        break	
	fi
done

if [ ${check} -eq 0 ]; then
	# ref
	# cd ./benchspec/CPU/${1}*/run/run_base_refspeed_mytest-m64.0000
	# test
	cd ./benchspec/CPU/${1}*/run/run_base_test_mytest-m64.0000
else
	# ref
	# cd ./benchspec/CPU/${1}*/run/run_base_refrate_mytest-m64.0000
	# test
	cd ./benchspec/CPU/${1}*/run/run_base_test_mytest-m64.0000
fi
specinvoke 
