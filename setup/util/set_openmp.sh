#!/bin/bash

function set_openmp() {
	echo -e "\n# Set OMP_NUM_THREADS to ${1}\nexport OMP_NUM_THREADS=${1}" >> ~/.bashrc
}

function unset_openmp() {
	sed -i "/# Set OMP_NUM_THREADS to $1/d" ~/.bashrc
	sed -i "/export OMP_NUM_THREADS=$1/d" ~/.bashrc
}

set_openmp 4
# unset_openmp 4

source ~/.bashrc


