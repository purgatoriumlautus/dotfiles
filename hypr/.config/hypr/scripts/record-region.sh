#!/bin/bash
# Toggle region screen recording

VIDEO_DIR="$HOME/Videos/screenrecords"
mkdir -p "$VIDEO_DIR"

if pgrep -x wf-recorder > /dev/null; then
    pkill -SIGINT wf-recorder
    notify-send "Recording saved" "$VIDEO_DIR"
else
    REGION=$(slurp)
    if [ -n "$REGION" ]; then
        FILENAME="$VIDEO_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
        notify-send "Recording started"
        wf-recorder -g "$REGION" -f "$FILENAME" &
    fi
fi
