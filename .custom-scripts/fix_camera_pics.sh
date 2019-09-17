#!/bin/bash

set -x

chmod 664 *.jpg *.mp4

for pic in *.jpg *.mp4;
do
    name=$(echo "$pic" | sed -r 's/^([0-9]{4})([0-9]{2})([0-9]{2})_([0-9]{2})([0-9]{2})([0-9]{2})(_HDR)?/\1\-\2\-\3\ \4\-\5\-\6/') 
    mv "$pic" "$name"
done
