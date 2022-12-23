#!/bin/bash

# Download youtube files and place them in the appropriate folder

# Set default paths for file downloads
DEFAULT_MEDIA_PATH="${HOME}/Downloads"


if [ -z "$1" ]; then
    # Get youtube url, make sure its not blank
    echo "Enter youtube url"
    read YOUTUBE_URL
else
    YOUTUBE_URL="$1"
fi

if [ -z "${YOUTUBE_URL}" ]; then
    echo "Youtube url must be entered"
    exit 1
fi

# download path will include name of the online video file, and then whatever extension
# yt-dlp wants to use
DOWNLOAD_PATH="${DEFAULT_MEDIA_PATH}/%(title)s.%(ext)s"

yt-dlp -o "${DOWNLOAD_PATH}" "${YOUTUBE_URL}"
exit 0
