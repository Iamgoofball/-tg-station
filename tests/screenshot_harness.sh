#!/usr/bin/env bash

# Screenshot harness for /tg/station using Wine and xvfb

# Start Xvfb virtual display
XVFB_DISPLAY=:99
Xvfb $XVFB_DISPLAY -screen 0 1920x1080x24 &

# Export display variable
export DISPLAY=$XVFB_DISPLAY

# Run BYOND with Wine
wine ~/.byond/bin/byond.exe

# Take screenshot using Wine and scrot
wine ~/.byond/bin/byond.exe -screenshot screenshot.png

# Kill Xvfb
killall Xvfb

echo "Screenshot saved as screenshot.png"