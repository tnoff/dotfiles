#!/bin/bash

# Assume invalid jpg is really a png file

set -e

if [ -z "$1" ]; then
    echo "Must have input file"
    exit 1
fi

correct_name=$(echo "$1" | sed -r 's/.jpe?g$/.png/')
mv "$1" "$correct_name"
convert "$correct_name" "$1"
rm "$correct_name"
