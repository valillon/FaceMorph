#!/bin/bash
# Rafael Redondo - Nov. 2018

usage()
{
	echo "Usage: $ ./run_morphing_with_videos <video1> <video2> <fps>"
}

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$3" == "" ]; then
	usage
	exit
fi

if [ ! -e "$1" ] || [ ! -e "$2" ]; then
	echo "Video file not found"
	usage
	exit
fi

fps=$3

bold=$(tput bold)
normal=$(tput sgr0)

filename=$(basename -- "$1")
filename1="${filename%.*}"
filename=$(basename -- "$2")
filename2="${filename%.*}"
path="${1%/*}"

echo "${bold}Uncompressing video files${normal}"
ffmpeg -i $1 $path/$filename1-%04d.png
ffmpeg -i $2 $path/$filename2-%04d.png

echo "${bold}Generating facial landmarks and morphing frames${normal}"
shopt -s nullglob
numframes1=($path/$filename1*.png)
numframes1=${#numframes1[@]}
numframes2=($path/$filename2*.png)
numframes2=${#numframes2[@]}
numframes=$(( $numframes1 < $numframes2 ? $numframes1 : $numframes2 ))

for i in $(seq -f "%04g" 1 $numframes ); do

	if [ ! -e "$path/$filename1-$i.png" ] || [ ! -e "$path/$filename2-$i.png" ]; then continue; fi;

	ii=$(echo $i | sed 's/^0*//')
	a=$(($ii * 100 / $numframes))
	echo "${bold}[$a%] Morphing frame $ii${normal}"

	cp $path/$filename1-$i.png $path/$filename1.png
	cp $path/$filename2-$i.png $path/$filename2.png

	python landmark_detector.py --i $path/$filename1.png
	python landmark_detector.py --i $path/$filename2.png

	python faceMorph.py -i1 $path/$filename1.png -i2 $path/$filename2.png -a $a
	mv $path/morph-*-a*.png $path/morph-$filename1-$filename2-$i.png

done

echo "${bold}Cleaning folder${normal}"
rm $path/$filename1*.png
rm $path/$filename2*.png
rm $path/*_landmarks.jpg
rm $path/*.txt

echo "${bold}Generating video file${normal}"
ffmpeg -f image2 -framerate $fps -r $fps -start_number 0 -pattern_type glob -i $path/morph-$filename1-$filename2-'*.png' -b:v 10M -pix_fmt yuv420p $path/$filename1-$filename2.mp4 -y

echo "Morphing finished!"
echo "Checkout results in $path/$filename1-$filename2.mp4"