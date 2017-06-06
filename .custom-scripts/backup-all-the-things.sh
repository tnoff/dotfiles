#!/bin/bash

LOCAL_ROOT="${HOME}"
MUSIC_EXT="/Music/"
VIDEO_EXT="/Videos/"
DOCS_EXT="/Documents/"
PICS_EXT="/Pictures/"

# Make sure user has specified destination output
if [ -z "$1" ] ; then
    echo "Need destination variable, exiting"
    exit 1
fi

destination=`echo "$1" | sed -r 's/\/$//'`

echo "Going to run the following rysnc commands, that cool?"
echo "rsync -rvuc --copy-links ${LOCAL_ROOT}${DOCS_EXT} ${destination}${DOCS_EXT} --delete"
echo "rsync -rvuc ${LOCAL_ROOT}${MUSIC_EXT} ${destination}${MUSIC_EXT} --delete"
echo "rsync -rvuc ${LOCAL_ROOT}${VIDEO_EXT} ${destination}${VIDEO_EXT} --delete"
echo "rsync -rvuc ${LOCAL_ROOT}${PICS_EXT} ${destination}${PICS_EXT} --delete"

echo "Enter: y/n"
read response

if [ "${response}" == "y" ] || [ "${response}" == "Y" ]; then
    echo "Running sync on docs"
    rsync -rvuc --copy-links ${LOCAL_ROOT}${DOCS_EXT} ${destination}${DOCS_EXT} --delete
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Running sync on music"
    rsync -rvuc ${LOCAL_ROOT}${MUSIC_EXT} ${destination}${MUSIC_EXT} --delete
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Running sync on videos"
    rsync -rvuc ${LOCAL_ROOT}${VIDEO_EXT} ${destination}${VIDEO_EXT} --delete
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Running sync on pictures"
    rsync -rvuc ${LOCAL_ROOT}${PICS_EXT} ${destination}${PICS_EXT} --delete
fi
