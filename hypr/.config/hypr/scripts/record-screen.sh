#!/bin/bash
# Toggle screen recording

VIDEO_DIR="$HOME/Videos/screenrecords"
mkdir -p "$VIDEO_DIR"

if pgrep -x wf-recorder > /dev/null; then
    pkill -SIGINT wf-recorder
    notify-send "Recording saved" "$VIDEO_DIR"
else
    FILENAME="$VIDEO_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
    notify-send "Recording started"
    wf-recorder -f "$FILENAME" &
fi
