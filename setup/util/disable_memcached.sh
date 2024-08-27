#!/bin/bash

function enable_memcached() {
	# Flush All
	echo "flush_all" | nc -q 2 localhost 11211

	# Turn Off Redis
	sudo systemctl status memcached
	sudo systemctl stop memcached
}

function disable_memcached() {
	sudo systemctl status memcached
	sudo systemctl stop memcached
}

disable_memcached
