#!/bin/bash

set -x

chmod 664 *.jpg

for pic in *.jpg;
do
    name=$(echo "$pic" | sed -r 's/^([0-9]{4})([0-9]{2})([0-9]{2})_([0-9]{2})([0-9]{2})([0-9]{2})(_HDR)?/\1\-\2\-\3\ \4\-\5\-\6/') 
    mv "$pic" "$name"
done
