#!/usr/bin/env python

import argparse
import os
import re

from hathor.audio import metadata
from hathor.exc import AudioFileException

'''
Most audio files you download tend to put the featured notes within the song title

Theres a better way to deal with this, which is put this info in the "artist" tag
of the audio file

The "albumartist" tag should contain the main artist
'''

FEAT_MATCH = r"^(?P<title>.*) ([\(\[] ?)?(?P<featuring>[Ff](ea)?t(uring)?(.)? [a-zA-Z0-9 ,\.]+)( ?[\)\]])?"

def parse_args():
    parser = argparse.ArgumentParser(description="Fix artist tags")
    parser.add_argument("-d", "--dry-run", action="store_true", help="Only do dry run")
    parser.add_argument("file_dir", help="File Dir")
    return parser.parse_args()

def main():
    args = parse_args()

    file_dir = os.path.abspath(args.file_dir)
    possible_bad_files = []

    for base_path, _, file_list in os.walk(file_dir):
        for file_name in file_list:
            full_path = os.path.join(base_path, file_name)
            try:
                tags = metadata.tags_show(full_path)
            except AudioFileException:
                print("ERROR: Cannot get tags for file", full_path)
                continue
            # Check title for featuring
            try:
                title = tags['title']
            except KeyError:
                print("ERROR: No title tag for audio file", full_path)
                continue
            # Check for possible featuring files
            if "feat." in title.lower() or "featuring" in title.lower() or "ft." in title.lower():
                possible_bad_files.append(full_path)

    # Assume that featuring data within paren ()
    # Grab data from paren
    new_data = dict()
    for bad_file in possible_bad_files:
        tags = metadata.tags_show(bad_file)
        title = tags['title']

        matcher = re.match(FEAT_MATCH, title)

        if not matcher:
            print("ERROR: Unable to find matching regex for file", bad_file)
            continue
        # Combine featuring to end of album artist
        try:
            artist = '%s %s' % (tags['albumartist'], matcher.group('featuring'))
        except KeyError:
            print("ERROR: No albumartist tag", bad_file)
            continue
        # Use stripped title
        title = matcher.group('title')
        new_data[bad_file] = {
            'artist' : artist,
            'title' : title
        }
        print("File path:", bad_file)
        print("New artist value", artist)
        print("New title", title)
        print("-------------------------------------------------------------")

    if not args.dry_run:
        user_input = input("Continue with fixing files?(y/n)")
        if user_input.lower() == 'y':
            for path, new_data in new_data.items():
                print("Updating file", path)
                metadata.tags_update(path, new_data)

if __name__ == '__main__':
    main()
