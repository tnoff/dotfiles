#!/usr/bin/env python

import argparse
import os
import re

from hathor.audio import metadata
import youtube_dl

EXPECTED_REGEX = "^0?(?P<number>[0-9A-Z]+)-(?P<title>.*).mp3"

def parse_args():
    p = argparse.ArgumentParser(description="Download youtube playlist")
    p.add_argument("playlist", help="Playlist URL")
    p.add_argument("--artist", help="Artist Name")
    p.add_argument("--album", help="Album Name")
    p.add_argument("--date", help="Date")
    p.add_argument("--picture", help="Picture file to use")
    return p.parse_args()

def main():
    args = parse_args()

    path = os.path.abspath('.')
    if args.artist:
        path = os.path.join(path, args.artist)

    # Add date to album path if possible
    if args.album and args.date:
        path = os.path.join(path, "%s-%s" % ( args.date, args.album ))

    if args.album and not args.date:
        path = os.path.join(path, args.album)

    # Make dir if needed
    try:
        os.makedirs(path)
    except FileExistsError:
        pass

    output = path + '/' + '%(playlist_index)s-%(title)s.%(ext)s'

    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl' : output,
        'postprocessors' : [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
            'preferredquality': '192',
        }],
    }
    with youtube_dl.YoutubeDL(ydl_opts) as ydl:
        ydl.download([args.playlist])


    # Give user time to fix file names if needed
    raw_input("Press Enter to continue")

    # Assume any files in path that end in mp3 are ours
    mp3_files = [file_name for file_name in os.listdir(path) if file_name.endswith('.mp3')]
    # Assume track total is number of files
    track_total = len(mp3_files)


    # Fix up tags on files
    tags_dict = {}
    if args.artist:
        tags_dict['artist'] = args.artist
        tags_dict['albumartist'] = args.artist
    if args.album:
        tags_dict['album'] = args.album
    if args.date:
        tags_dict['date'] = args.date

    for file_name in mp3_files:
        match = re.search(EXPECTED_REGEX, file_name)
        tags_dict['tracknumber'] = '%s/%s' % (match.group('number'),track_total)
        tags_dict['title'] = match.group('title')
        print("Updating file %s with dict %s" % (file_name, tags_dict))
        metadata.tags_update(os.path.join(path, file_name), tags_dict)

        if args.picture:
            metadata.picture_update(os.path.join(path, file_name), args.picture)


if __name__ == '__main__':
    main()
