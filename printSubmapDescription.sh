#!/bin/sh

awk "/^submap=$1\$/,/^submap=reset\$/" /home/gordo/.config/hypr/hyprland.conf | awk '/^#desc / { sub(/^#desc /,""); print }'

if [ $# -eq 2 ]; then
    sleep $2
fi
