#!/bin/bash

# Flush All
redis-cli flushall

# Turn Off Redis
sudo systemctl status redis-server
sudo systemctl stop redis-server
