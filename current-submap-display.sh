#!/usr/bin/env bash

FILE="$HOME/.local/state/hypr/keychords/current-submap.txt"
CONFIG_DIR="$HOME/.config/hypr"

guide_pid=""

# Monitor file for modifications, creations, or deletions
inotifywait -m -e modify --format '%w%f %e' $FILE |
while read file event; do

    kill -9 $guide_pid

    file_contents="$(cat $file)"
    if [[ $file_contents =~ ^reset$ ]]; then
        continue
    fi

    file_contents="${file_contents#"${file_contents%%[![:space:]]*}"}"
    file_contents="${file_contents%"${file_contents##*[![:space:]]}"}"

    alacritty --class 'wm-float-noanim' -e "$CONFIG_DIR/printSubmapDescription.sh" "$file_contents" 20 &
    guide_pid=$!

done

