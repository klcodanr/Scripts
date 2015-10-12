#!/bin/bash

for image in ~/Dropbox/IFTTT/hotredditwallpaper/*
do
	height=$(sips -g pixelHeight "$image" | tail -n1 | cut -d" " -f4)
	width=$(sips -g pixelWidth "$image" | tail -n1 | cut -d" " -f4)
	if [ "$height" = "" ] || [ "$width" = "" ]; then
		echo "Removing: $image"
		rm "$image"
		continue
	fi
	if (("$height" < "900")) || (("$width" < "600")); then
		echo "Removing: $image"
		rm "$image"
	fi
	if (("$height" > "2880")) || (("$width" > "2880")); then
		echo "Resizing: $image"
		sips -Z 2880 "$image"
	fi
done
