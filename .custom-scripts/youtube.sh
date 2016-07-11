#!/bin/bash

# Download youtube files and place them in the appropriate folder

DEFAULT_MEDIA_PATH="/home/tnorth/Media"
DEFAULT_MUSIC_PATH="${DEFAULT_MEDIA_PATH}/Music"
DEFAULT_VIDEO_PATH="${DEFAULT_MEDIA_PATH}/Videos"

DEFAULT_FILE_ENDING=".mp4"

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

if [ "${MEDIA_TYPE}" -ne "v" ] || [ "${MEDIA_TYPE}" -ne "m" ]; then
    echo "Invalid media type, must be [v] or [m]"
    exit 1
fi


if [ "${MEDIA_TYPE}" -eq "m" ]; then

    echo "Enter song name"
    read SONG_NAME

    if [ -z "${SONG_NAME}" ]; then
        echo "Song name must be entered"
        exit 1
    fi

    echo "Enter artist name (if None press enter)"
    read ARTIST_NAME

    if [ -z "${ARTIST_NAME}" ]; then
        DOWNLOAD_PATH="${DEFAULT_MUSIC_PATH}/${SONG_NAME}${DEFAULT_FILE_ENDING}"
        youtube-dl -f best --audio-quality 0 -x -o "${DOWNLOAD_PATH}" "${YOUTUBE_URL}"
        audio-tool tags reset --title "${SONG_NAME}" "${DOWNLOAD_PATH}"
    else
        echo "Enter album name (if None press enter)"
        read ALBUM_NAME
        if [ -z "${ALBUM_NAME}" ]; then
            DOWNLOAD_PATH="${DEFAULT_MUSIC_PATH}/${ARTIST_NAME}/${SONG_NAME}${DEFAULT_FILE_ENDING}"
            youtube-dl -f best --audio-quality 0 -x -o "${DOWNLOAD_PATH}" "${YOUTUBE_URL}"
            audio-tool tags reset --title "${SONG_NAME}" --artist "${ARTIST_NAME}" --performer "${ARTIST_NAME}" "${DOWNLOAD_PATH}"
        else
            DOWNLOAD_PATH="${DEFAULT_MUSIC_PATH}/${ARTIST_NAME}/${ALBUM_NAME}/${SONG_NAME}"
            youtube-dl -f best --audio-quality 0 -x -o "${DOWNLOAD_PATH}${DEFAULT_FILE_ENDING}" "${YOUTUBE_URL}"
            audio-tool tags reset --title "${SONG_NAME}" --artist "${ARTIST_NAME}" --performer "${ARTIST_NAME}" --album "${ALBUM_NAME}" "${DOWNLOAD_PATH}"
        fi
    fi
fi

if [ "$MEDIA_TYPE}" -eq "v" ]; then

    echo "Enter video name"
    read VIDEO_NAME

    if [ -z "${VIDEO_NAME}" ]; then
        echo "Video name must be entered"
        exit 1
    fi
    
    DOWNLOAD_PATH="${DEFAULT_VIDEO_PATH}/${VIDEO_NAME}/${DEFAULT_FILE_ENDING}"
    youtube-dl -f best --audio-quality 0 -o "${DOWNLOAD_PATH}" "${YOUTUBE_URL}"
fi
