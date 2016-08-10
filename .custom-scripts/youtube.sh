#!/bin/bash

# Download youtube files and place them in the appropriate folder

DEFAULT_MEDIA_PATH="/home/tnorth/Media"
DEFAULT_MUSIC_PATH="${DEFAULT_MEDIA_PATH}/Music"
DEFAULT_VIDEO_PATH="${DEFAULT_MEDIA_PATH}/Videos"

echo "Enter youtube url"
read YOUTUBE_URL

if [ -z "${YOUTUBE_URL}" ]; then
    echo "Youtube url must be entered"
    exit 1
fi

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

if [ "${MEDIA_TYPE}" == "m" ]; then

    echo "Enter artist name (if None press enter)"
    read ARTIST_NAME

    if [ -z "${ARTIST_NAME}" ]; then
        DOWNLOAD_PATH="${DEFAULT_MUSIC_PATH}"
    else
        echo "Enter album name (if None press enter)"
        read ALBUM_NAME
        if [ -z "${ALBUM_NAME}" ]; then
            mkdir -p "${DEFAULT_MUSIC_PATH}/${ARTIST_NAME}"
            DOWNLOAD_PATH="${DEFAULT_MUSIC_PATH}/${ARTIST_NAME}"
        else
            mkdir -p "${DEFAULT_MUSIC_PATH}/${ARTIST_NAME}/${ALBUM_NAME}"
            DOWNLOAD_PATH="${DEFAULT_MUSIC_PATH}/${ARTIST_NAME}/${ALBUM_NAME}"
        fi
    fi
    youtube-dl -f best --audio-quality 0 -x -o "${DOWNLOAD_PATH}/%(title)s.%(ext)s" "${YOUTUBE_URL}"
    exit 0
fi

if [ "${MEDIA_TYPE}" == "v" ]; then

    DOWNLOAD_PATH="${DEFAULT_VIDEO_PATH}/%(title)s.%(ext)s"
    youtube-dl -f best --audio-quality 0 -o "${DOWNLOAD_PATH}" "${YOUTUBE_URL}"
    exit 0
fi
exit 1
