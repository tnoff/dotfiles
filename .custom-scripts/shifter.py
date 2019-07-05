#!/usr/bin/env python
import logging
from logging.handlers import RotatingFileHandler
import os
import random

HOME_DIRECTORY = os.path.expanduser('~')
PICTURE_DIRECTORY = os.path.join(HOME_DIRECTORY, 'Pictures', 'Wallpapers')
PICTURE_LIST_FILE = os.path.join(HOME_DIRECTORY, '.shifter_files')
LOG_FILE = os.path.join(HOME_DIRECTORY, '.shifter_log')
WAIT_INTERVAL = 300

def setup_logger():
    logger = logging.getLogger(__name__)
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s',
                                  datefmt='%Y-%m-%d %H:%M:%S')
    logger.setLevel(logging.DEBUG)
    fh = RotatingFileHandler(LOG_FILE,
                             backupCount=0,
                             maxBytes=((2 ** 10) * 5),)
    fh.setLevel(logging.DEBUG)
    fh.setFormatter(formatter)
    logger.addHandler(fh)
    return logger

def reset_files():
    # First attempt to read files
    try:
        with open(PICTURE_LIST_FILE, 'r') as reader:
            files = reader.read().split('\n')
    except FileNotFoundError:
        files = []
    # If no files left, reset picture file
    if len(files) == 0:
        files = os.listdir(PICTURE_DIRECTORY)
        # Shuffle a couple of times before writing
        for _ in range(len(files) * 2):
            random.shuffle(files)

    # Make sure file exists when getting it
    while True:
        # Grab first file to return later
        file_name = os.path.join(PICTURE_DIRECTORY, files.pop(0))
        if os.path.isfile(file_name):
            break
    # Write rest of files to file for later
    with open(PICTURE_LIST_FILE, 'w') as writer:
        writer.write('\n'.join(i for i in files))
    return file_name

def main():
    log = setup_logger()
    file_name = reset_files()
    # add condition to check if file doesnt exist
    log.debug("Changing background to file name:%s", file_name)
    os.system('gsettings set org.gnome.desktop.background picture-uri "file:///%s"' % file_name)
    os.system('gsettings set org.gnome.desktop.screensaver picture-uri "file:///%s"' % file_name)

if __name__ == '__main__':
    main()
