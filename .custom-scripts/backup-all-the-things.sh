#!/bin/bash

set -euf -o pipefail

# Default File Locations
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

LOG_FILE="/tmp/backup.log"

# Remove trailing backslash in destination
destination=`echo "$1" | sed -r 's/\/$//'`

# Backup commands
docs_sync="rsync -rvputogcL ${LOCAL_ROOT}${DOCS_EXT} ${destination}${DOCS_EXT} --delete"
music_sync="rsync -rvuptogcL ${LOCAL_ROOT}${MUSIC_EXT} ${destination}${MUSIC_EXT} --delete"
pic_sync="rsync -rvuptogc ${LOCAL_ROOT}${PICS_EXT} ${destination}${PICS_EXT} --delete"
video_sync="rsync -rvuptogc ${LOCAL_ROOT}${VIDEO_EXT} ${destination}${VIDEO_EXT} --delete"

echo "Will run the following rysnc commands"
echo "--------------------------------------------------------------------"

echo "${docs_sync}"
echo "${music_sync}"
echo "${pic_sync}"
echo "${video_sync}"

echo "--------------------------------------------------------------------"
echo "Enter (Y|y) to continue"
read response

if [ "${response}" == "y" ] || [ "${response}" == "Y" ]; then

    {
        # Start backups
        echo "Running doc sync"
        eval "${docs_sync}"

        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

        echo "Running music sync"
        eval "${music_sync}"

        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

        echo "Running pic sync"
        eval "${pic_sync}"

        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

        echo "Running video sync"
        eval "${video_sync}"

    } > "${LOG_FILE}" # Write all output to log file

    echo "Finished!"
fi
