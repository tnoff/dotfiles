#!/bin/bash

LOCAL_ROOT="${HOME}"
MUSIC_EXT="/Music/"
VIDEO_EXT="/Videos/"
DOCS_EXT="/Documents/"

# Make sure user has specified destination output
if [ -z "$1" ] ; then
    echo "Need destination variable, exiting"
    exit 1
fi

destination=`echo "$1" | sed -r 's/\/$//'`

echo "Going to run the following rysnc commands, that cool?"
echo "rsync -rvauc ${LOCAL_ROOT}${DOCS_EXT} ${destination}${DOCS_EXT} --delete"
echo "rsync -rvauc ${LOCAL_ROOT}${MUSIC_EXT} ${destination}${MUSIC_EXT} --delete"
echo "rsync -rvau ${LOCAL_ROOT}${VIDEO_EXT} ${destination}${VIDEO_EXT} --delete"

echo "Enter: y/n"
read response

if [ "${response}" == "y" ] || [ "${response}" == "Y" ]; then
    echo "Running sync on docs"
    rsync -rvauc ${LOCAL_ROOT}${DOCS_EXT} ${destination}${DOCS_EXT} --delete
    echo "Running sync on music"
    rsync -rvauc ${LOCAL_ROOT}${MUSIC_EXT} ${destination}${MUSIC_EXT} --delete
    echo "Running sync on videos"
    rsync -rvau ${LOCAL_ROOT}${VIDEO_EXT} ${destination}${VIDEO_EXT} --delete
fi