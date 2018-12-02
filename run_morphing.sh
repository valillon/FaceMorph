#!/bin/bash
# Rafael Redondo - Nov. 2018

usage()
{
	echo "Usage: $ run_morphing <image1> <image2> <fps> <duration>"
}

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ] || [ "$4" == "" ]; then
	usage
	exit
fi

if [ ! -e "$1" ] || [ ! -e "$2" ]; then
	echo "Image not found"
	usage
	exit
fi

fps=$3
duration=$4
frames=$(($fps * $duration))

bold=$(tput bold)
normal=$(tput sgr0)

echo "${bold}Generating facial landmarks${normal}"
python landmark_detector.py --i $1
python landmark_detector.py --i $2

echo "${bold}Creating morphing frames${normal}"
python faceMorph.py -i1 $1 -i2 $2 -f $frames

echo "${bold}Generating video file${normal}"
filename=$(basename -- "$1")
filename1="${filename%.*}"
filename=$(basename -- "$2")
filename2="${filename%.*}"
path="${1%/*}"
ffmpeg -framerate $fps -r $fps -start_number 0 -i $path/$filename1-$filename2-%04d.png -b:v 10M -pix_fmt yuv420p $path/$filename1-$filename2.mp4 -y