#!/bin/bash

function disable_redis(){
	# Flush All
	redis-cli flushall

	# Turn Off Redis
	sudo systemctl status redis-server
	sudo systemctl stop redis-server
}

fuction enable_redis(){
	sudo systemctl status redis-server
	sudo systemctl start redis-server
}
