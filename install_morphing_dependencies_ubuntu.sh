#!/bin/bash
#
# This script installs several dependencies to make Dlib work.
# From https://www.learnopencv.com/install-dlib-on-ubuntu
#
# Troubleshooting: if for some reasong pip3 is not found reinstall pip3 as
# sudo apt-get remove python3-pip; sudo apt-get install python3-pip
#
# Rafael Redondo - Dec. 2018

# Ubuntu dependencies
sudo apt-get install build-essential cmake pkg-config
sudo apt-get install libx11-dev libatlas-base-dev
sudo apt-get install libgtk-3-dev libboost-python-dev

# Python dependencies
sudo apt-get install python-dev python-pip python3-dev python3-pip
sudo -H pip2 install -U pip numpy
sudo -H pip3 install -U pip numpy
pip install imutils

# Install Dlib from pip
pip install dlib

# # Compile Dlib from code
# if [ ! -d ./dlib-19.6 ]; then
# 	if [ ! -f "./dlib-19.6.tar.bz2" ]; then
# 		wget http://dlib.net/files/dlib-19.6.tar.bz2	
# 	fi
# 	tar xvf dlib-19.6.tar.bz2
# 	sudo rm -rf dlib-19.6.tar.bz2
# fi

# cd dlib-19.6
# python setup.py install
# # clean up(this step is required if you want to build dlib for both Python2 and Python3)
# # rm -rf dist
# # rm -rf tools/python/build
# # rm python_examples/dlib.so
# cd ..