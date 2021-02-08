#!/bin/bash

PICTURE=/tmp/i3lock.png
SCREENSHOT="scrot $PICTURE"

BLUR="10x5"

$SCREENSHOT
convert $PICTURE -blur $BLUR $PICTURE
i3lock -n -i $PICTURE
rm $PICTURE