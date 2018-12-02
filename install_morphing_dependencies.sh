#!/bin/bash
#
# This script installs several dependencies to make face morphing work.
# Basically dlib for landmark detection, opencv for processing images,
# some python tools and ffmpeg for generating video from raw frames.
#
# Troubleshooting:
#
# If your bash does not find ruby or brew, try to launch them from
# /usr/bin/ruby and /usr/local/bin/brew.
#
# If for some reason during the installation steps
# the pip command gets unliked try to upgrade like this: `$ sudo python -m pip install --upgrade numpy`
# Don't know how the heck worked, but it got pip back to me.
#
# Rafael Redondo - Nov. 2018

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update

brew install ffmpeg
brew install python
brew install python3
brew install cmake
brew install boost
brew install boost-python --with-python3

pip install numpy
pip install scipy
pip install scikit-image
pip install matplotlib
pip install imutils
pip install opencv-python
pip install dlib

