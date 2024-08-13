#!/bin/bash

# Flush All
echo "flush_all" | nc -q 2 localhost 11211

# Turn Off Redis
sudo systemctl status memcached
sudo systemctl stop memcached
