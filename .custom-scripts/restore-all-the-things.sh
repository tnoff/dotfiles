#!/bin/bash

LOCAL_ROOT="${HOME}"
MUSIC_EXT="/Music/"
VIDEO_EXT="/Videos/"
DOCS_EXT="/Documents/"

# Make sure user has specified destination output
if [ -z "$1" ] ; then
    echo "Need origin variable, exiting"
    exit 1
fi

origin=`echo "$1" | sed -r 's/\/$//'`

echo "Going to run the following rysnc commands, that cool?"
echo "rsync -rvc ${origin}${DOCS_EXT} ${LOCAL_ROOT}${DOCS_EXT} --delete"
echo "rsync -rvc ${origin}${MUSIC_EXT} ${LOCAL_ROOT}${MUSIC_EXT} --delete"
echo "rsync -rvc ${origin}${VIDEO_EXT} ${LOCAL_ROOT}${VIDEO_EXT} --delete"

echo "Enter: y/n"
read response

if [ "${response}" == "y" ] || [ "${response}" == "Y" ]; then
    echo "Running sync on docs"
    rsync -rvc ${origin}${DOCS_EXT} ${LOCAL_ROOT}${DOCS_EXT} --delete
    echo "Running sync on music"
    rsync -rvc ${origin}${MUSIC_EXT} ${LOCAL_ROOT}${MUSIC_EXT} --delete
    echo "Running sync on videos"
    rsync -rvc ${origin}${VIDEO_EXT} ${LOCAL_ROOT}${VIDEO_EXT} --delete
fi
