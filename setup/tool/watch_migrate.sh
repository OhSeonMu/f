#!/bin/bash

watch -n 1 "cat /proc/vmstat | grep migrate"
