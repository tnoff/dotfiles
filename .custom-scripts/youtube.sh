#!/bin/bash

# Download youtube files and place them in the appropriate folder

# Set default paths for file downloads
DEFAULT_MEDIA_PATH="${HOME}/Downloads"

# Get youtube url, make sure its not blank
echo "Enter youtube url"
read YOUTUBE_URL

if [ -z "${YOUTUBE_URL}" ]; then
    echo "Youtube url must be entered"
    exit 1
fi


# Enter media type
# audio - will only download audio if possible
# video - download the whole video
echo "Enter Media Type: (a)udio or (v)ideo"
read MEDIA_TYPE

if [ -z "${MEDIA_TYPE}" ]; then
    echo "Media type must be entered"
    exit 1
fi

if [ "${MEDIA_TYPE}" != "v" ] && [ "${MEDIA_TYPE}" != "a" ]; then
    echo "Invalid media type, must be [v] or [a]"
    exit 1
fi

# download path will include name of the online video file, and then whatever extension
# yt-dlp wants to use
DOWNLOAD_PATH="${DEFAULT_MEDIA_PATH}/%(title)s.%(ext)s"

if [ "${MEDIA_TYPE}" == "a" ]; then

    # download best possible format, use "-x" flag for just audio
    yt-dlp -x -o "${DOWNLOAD_PATH}" "${YOUTUBE_URL}"
    exit 0
fi

if [ "${MEDIA_TYPE}" == "v" ]; then
    yt-dlp -o "${DOWNLOAD_PATH}" "${YOUTUBE_URL}"
    exit 0
fi
exit 1
