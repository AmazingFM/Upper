#!/bin/bash
DIRECTORY=$1

FILES="$(find "$DIRECTORY" -name '*.png')"
for file in $FILES
do
echo "---------$file"
sips -m "/System/Library/Colorsync/Profiles/sRGB Profile.icc" $file --out $file
done
echo "------------------------------"
echo "script successfully finished"
echo "------------------------------"
