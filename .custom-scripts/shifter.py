#!/usr/bin/env python
import logging
from logging.handlers import RotatingFileHandler
import os
import random
import time

HOME_DIRECTORY = os.path.expanduser('~')
PICTURE_DIRECTORY = os.path.join(HOME_DIRECTORY, 'Pictures', 'Wallpapers')
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
    files = os.listdir(PICTURE_DIRECTORY)
    for _ in range(len(files) * 2):
        random.shuffle(files)
    return files

def main():
    files = reset_files()
    log = setup_logger()
    while True:
        if len(files) == 0:
            log.warning("No more files left, resetting file list")
            files = reset_files()
        file_name = os.path.join(PICTURE_DIRECTORY, files.pop(0))
        # add condition to check if file doesnt exist
        if not os.path.isfile(file_name):
            log.error("Unable to find file:%s, resetting file list", file_name)
            files = reset_files()
            continue
        log.debug("Changing background to file name:%s", file_name)
        os.system('gsettings set org.gnome.desktop.background picture-uri "file:///%s"' % file_name)
        time.sleep(WAIT_INTERVAL)

if __name__ == '__main__':
    main()
