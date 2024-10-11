#!/bin/bash

function disable_redis(){
	# Flush All
	redis-cli flushall

	# Turn Off Redis
	sudo systemctl status redis-server
	sudo systemctl stop redis-server
}

function enable_redis(){
	sudo systemctl status redis-server
	sudo systemctl start redis-server
}

disable_redis
