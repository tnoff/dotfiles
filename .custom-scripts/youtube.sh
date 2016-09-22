#!/bin/bash

# Download youtube files and place them in the appropriate folder

# Set default paths for file downloads
DEFAULT_MEDIA_PATH="${HOME}/Downloads"

# Make sure all needed dirs exist
mkdir -p "${DEFAULT_MEDIA_PATH}"


# Get youtube url, make sure its not blank
echo "Enter youtube url"
read YOUTUBE_URL

if [ -z "${YOUTUBE_URL}" ]; then
    echo "Youtube url must be entered"
    exit 1
fi


# Enter media type
# music - will only download audio if possible
# video - download the whole video
echo "Enter Media Type: (m)usic of (v)ideo"
read MEDIA_TYPE

if [ -z "${MEDIA_TYPE}" ]; then
    echo "Media type must be entered"
    exit 1
fi

if [ "${MEDIA_TYPE}" != "v" ] && [ "${MEDIA_TYPE}" != "m" ]; then
    echo "Invalid media type, must be [v] or [m]"
    exit 1
fi

# If music, also ask for artist and then album.
# if given, dirs will be created to place
# file in the appropriate place.
if [ "${MEDIA_TYPE}" == "m" ]; then

    echo "Enter artist name (if None press enter)"
    read ARTIST_NAME

    if [ -z "${ARTIST_NAME}" ]; then
        DOWNLOAD_PATH="${DEFAULT_MEDIA_PATH}"
    else
        echo "Enter album name (if None press enter)"
        read ALBUM_NAME
        if [ -z "${ALBUM_NAME}" ]; then
            mkdir -p "${DEFAULT_MEDIA_PATH}/${ARTIST_NAME}"
            DOWNLOAD_PATH="${DEFAULT_MEDIA_PATH}/${ARTIST_NAME}"
        else
            mkdir -p "${DEFAULT_MEDIA_PATH}/${ARTIST_NAME}/${ALBUM_NAME}"
            DOWNLOAD_PATH="${DEFAULT_MEDIA_PATH}/${ARTIST_NAME}/${ALBUM_NAME}"
        fi
    fi
    # download best possible format, use "-x" flag for just audio
    # download path will include name of the online video file, and then whatever extension
    # youtube-dl wants to use
    youtube-dl -f best --audio-quality 0 -x -o "${DOWNLOAD_PATH}/%(title)s.%(ext)s" "${YOUTUBE_URL}"
    exit 0
fi

if [ "${MEDIA_TYPE}" == "v" ]; then

    DOWNLOAD_PATH="${DEFAULT_MEDIA_PATH}/%(title)s.%(ext)s"
    youtube-dl -f best --audio-quality 0 -o "${DOWNLOAD_PATH}" "${YOUTUBE_URL}"
    exit 0
fi
exit 1
