#!/bin/bash

STYLUS="Wacom Bamboo Pen Pen stylus"
ERASER="Wacom Bamboo Pen Pen eraser"

AREA=$(xrandr | grep 1050x1680 | head -1 | cut -d " " -f 3)
ROTATION=ccw

if [ -z AREA ]; then
	AREA=$(xrandr | grep 1680x1050 | head -1 | cut -d " " -f 3)
	ROTATION=half
fi

for DEVICE in "$STYLUS" "$ERASER"; do
	echo "Setting $DEVICE rotation to '$ROTATION'"
	xsetwacom --set "$DEVICE" Rotate "$ROTATION"
	if [ -v AREA ]; then
		echo "Mapping $DEVICE to '$AREA'"
		xsetwacom --set "$DEVICE" MapToOutput "$AREA"
	fi
done
