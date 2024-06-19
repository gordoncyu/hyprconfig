#!/usr/bin/env bash

invert_match=0

while getopts ":v" opt; do
    case ${opt} in
        v )
            invert_match=1
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            ;;
    esac
done
shift $((OPTIND -1))

if [[ $# -ne 1 ]]; then
    echo "Script needs exactly one argument" 1>&2
    exit 1
fi

if [[ $invert_match -eq 1 ]]; then
    hyprctl clients -j | jq -r '.[] | select(.initialClass | test("(?:^|\\s)hyprKeychordGuide\\b")) | select(.initialClass | test("(?:^|\\s)hyprKeychordGuide-'"$1"'(?:$|\\s)") | not ).pid ' | xargs kill -9
else
    hyprctl clients -j | jq -r '.[] | select(.initialClass | test("(?:^|\\s)hyprKeychordGuide-'"$1"'(?:$|\\s)")).pid ' | xargs kill -9
fi

