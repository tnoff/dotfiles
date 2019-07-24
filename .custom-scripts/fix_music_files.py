#!/usr/bin/env python

import argparse
import json
import logging
from logging import FileHandler
import os
import re

from hathor.audio import metadata
from hathor.exc import AudioFileException

FEAT_MATCH = r"^(?P<title>.*[^\[\(]) ([\(\[] ?)?(?P<featuring>[Ff](ea)?t(uring)?(.)? .*[^\]\) ])( [\)\]])?"

def parse_args():
    parser = argparse.ArgumentParser(description="Fix artist tags")
    parser.add_argument("-d", "--dry-run", action="store_true", help="Only do dry run")
    parser.add_argument("-l", "--log-file", default="/tmp/music-tags.log",
                        help="Log File")
    parser.add_argument("file_dir", help="File Dir with Music Files")
    return parser.parse_args()

def setup_logger(log_file):
    logger = logging.getLogger(__name__)
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s',
                                  datefmt='%Y-%m-%d %H:%M:%S')
    logger.setLevel(logging.DEBUG)
    fh = FileHandler(log_file)
    fh.setLevel(logging.DEBUG)
    fh.setFormatter(formatter)
    logger.addHandler(fh)
    return logger

def check_file(log, update_data, delete_tags, full_path):
    try:
        tags = metadata.tags_show(full_path)
    except AudioFileException:
        log.error("Cannot get tags for file:%s", full_path)
        return update_data, delete_tags

    update_data = check_featured_artists_in_title(log, update_data,
                                                  full_path, tags)
    delete_tags = check_genre_defined(log, delete_tags, full_path, tags)
    return update_data, delete_tags


def check_genre_defined(log, delete_tags, full_path, tags):
    '''
    I dont like the genre tag in the audio file
    unless its a podcast
    '''
    try:
        genre = tags['genre']
    except KeyError:
        return delete_tags
    if genre.lower() != 'podcast':
        log.debug("File:%s has genre:%s, marking for deletion",
                  full_path, tags['genre'])
        delete_tags.setdefault('genre', set([]))
        delete_tags['genre'].add(full_path)
    return delete_tags

def check_featured_artists_in_title(log, update_data, full_path, tags):
    '''
    Most audio files you download tend to put the featured notes within the song title

    Theres a better way to deal with this, which is put this info in the "artist" tag
    of the audio file

    The "albumartist" tag should contain the main artist
    '''
    # Check title for featuring
    try:
        title = tags['title']
    except KeyError:
        log.error("No title tag for audio file:%s", full_path)
        return update_data

    # Check for possible featuring files
    if not ("feat." in title.lower() or "featuring" in title.lower() or "ft." in title.lower()):
        log.debug("No featuring artist in title found for file:%s", title)
        return update_data

    matcher = re.match(FEAT_MATCH, title)

    if not matcher:
        log.warning("Unable to find matching regex for file:%s", full_path)
        return update_data
    # Combine featuring to end of album artist
    try:
        artist = '%s %s' % (tags['albumartist'], matcher.group('featuring'))
    except KeyError:
        log.warning("No albumartist tag:%s", full_path)
        return update_data
    # Use stripped title
    title = matcher.group('title')
    # Dont assume nothing in update_data key yet
    update_data.setdefault(full_path, {})
    update_data[full_path]['artist'] = artist
    update_data[full_path]['title'] = title

    return update_data

def main():
    args = parse_args()
    log = setup_logger(args.log_file)
    file_dir = os.path.abspath(args.file_dir)

    # Update data will track the file path
    # And what tags will need to be updated
    update_data = dict()

    # Delete tags will track tags that should be deleted
    delete_tags = dict()

    for base_path, _, file_list in os.walk(file_dir):
        for file_name in file_list:

            # Don't check 'low-quality' files
            if file_name == 'low-quality':
                continue

            full_path = os.path.join(base_path, file_name)
            log.debug("Checking file:%s", full_path)
            update_data, delete_tags = check_file(log, update_data, delete_tags, full_path)

    # Print out data fixes before continuing
    for path, new_tags in update_data.items():
        print("Will attempt to edit tags on file:", path)
        print("New tags\n:", json.dumps(new_tags, indent=4))

    for tag, data_set in delete_tags.items():
        print("Will attempt to delete tag:%s from the following files" % tag)
        for item in data_set:
            print(item)

    if not args.dry_run:
        user_input = input("Continue with fixing files?(y/n)")
        if user_input.lower() == 'y':
            for path, new_data in update_data.items():
                log.info("Updating file:%s", path)
                metadata.tags_update(path, new_data)
            for tag, data_set in delete_tags.items():
                for item in data_set:
                    log.info("Removing tag:%s from file:%s", tag, item)
                    metadata.tags_delete(item, [tag])

if __name__ == '__main__':
    main()
