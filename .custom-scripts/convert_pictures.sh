#!/bin/bash

# Convert pictures to more readable time format

echo "Using the following names for files"

for PIC in $(ls *.jpg); do
    echo "${PIC}" | sed -r 's/^([0-9]{4})([0-9]{2})([0-9]{2})_([0-9]{2})([0-9]{2})([0-9]{2})(_HDR)?/\1\-\2\-\3\ \4\-\5\-\6/'
done

echo "OK to rename?"

read INPUT

if [ "${INPUT}" == "y" ]; then
    for PIC in $(ls *.jpg); do
        NAME=$(echo "${PIC}" | sed -r 's/^([0-9]{4})([0-9]{2})([0-9]{2})_([0-9]{2})([0-9]{2})([0-9]{2})(_HDR)?/\1\-\2\-\3\ \4\-\5\-\6/')
        mv "${PIC}" "${NAME}"
    done
fi
