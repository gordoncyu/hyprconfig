#!/usr/bin/env bash

# Ensures a number range is passed as the first argument
if [ -z "$1" ]; then
    echo "Usage: $0 <number range>"
    exit 1
fi
eval "number_range=($(echo $1))"
script_dir=$(echo $0 | xargs -I{} realpath '{}' | xargs -I{} readlink -f '{}' | xargs -I{} dirname '{}')  # Gets the directory where the script resides
echo "$script_dir"

# Loop through each number in the range
for i in ${number_range[@]}; do
    # Binding for switching to super workspace
    hyprctl keyword bind "Super, $i, exec, hyprctl dispatch submap sw${i}openswitch; $script_dir/switch-super-workspace.sh $i;"
    hyprctl keyword submap "sw${i}openswitch"

    # Bind keys 1 through 9 and 0 for workspaces 11 through 20 (assuming 20 workspaces)
    for (( j=1; j<=10; j++ )); do
        # Use modulo to handle the case where j=10 should map to workspace 20
        k=$((10*$i + j % 10))
        hyprctl keyword bind ", $j, workspace, $k"
        hyprctl keyword bind ", $j, submap, reset"
    done

    hyprctl keyword bind ", catchall, submap, reset"
    hyprctl keyword submap "reset"

    # Binding for moving focused window to new super workspace
    hyprctl keyword bind "Super Shift, $i, submap, sw${i}moveworkspace"
    hyprctl keyword submap "sw${i}moveworkspace"
    
    for (( j=1; j<=10; j++ )); do
        k=$((10*$i + j % 10))
        hyprctl keyword bind ", $j, movetoworkspacesilent, $k"
        hyprctl keyword bind ", $j, submap, reset"
    done

    hyprctl keyword bind ", catchall, submap, reset"
    hyprctl keyword submap "reset"
done

