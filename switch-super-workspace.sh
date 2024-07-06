#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Please provide a number as an argument."
    exit 1
fi

for i in {0..9}; do
    trueworkspace=$(($1 * 10 + $i))
    if [[ $i -eq 0 ]]; then
        trueworkspace=$(($trueworkspace + 10))
    fi
    echo "$i $trueworkspace"

    hyprctl keyword unbind "Alt, $i"
    hyprctl keyword unbind "Alt Shift, $i"
    hyprctl keyword bind "Alt, $i, workspace, $trueworkspace"
    hyprctl keyword bind "Alt Shift, $i, movetoworkspacesilent, $trueworkspace"
done
