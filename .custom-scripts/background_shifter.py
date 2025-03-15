#!/usr/bin/env python

'''
Background shifter program
'''

from argparse import ArgumentParser
from logging import getLogger, basicConfig
from random import shuffle
from pathlib import Path
from os import system
from time import sleep

PICTURE_DIR_DEFAULT = Path.home() / 'Pictures' / 'Wallpapers'
LOG_PATH_DEFAULT = Path.home() / '.shifter.log'
DEFAULT_WAIT_INTERVAL = 600 # seconds

def parse_args():
    p = ArgumentParser(description='Background Shifter Program')
    p.add_argument('--picture-dir', '-p', default=str(PICTURE_DIR_DEFAULT), help='Picture Directory')
    p.add_argument('--log-path', '-l', default=str(LOG_PATH_DEFAULT), help='Log path default')
    p.add_argument('--wait-interval', '-w', type=int, default=DEFAULT_WAIT_INTERVAL, help='Wait time in between changes')
    return p.parse_args()

def generate_file_list(picture_dir):
    files = []
    for item in picture_dir.glob('*'):
        files.append(item)

    for _ in range(5):
        shuffle(files)
    return files

def main():
    args = parse_args()
    
    picture_dir_path = Path(args.picture_dir)
    if not picture_dir_path.exists():
        print(f'Invalid picture directory {picture_dir_path}')
        return 0
    
    files = []

    logger = getLogger('background_shifter')
    basicConfig(filename=args.log_path, format='%(asctime)s %(levelname)s %(message)s', datefmt='%Y-%m-%d-%H-%M-%S', encoding='utf-8', level=20)
    logger.info('Starting shifter loop')
    while True:
        if not files:
            files = generate_file_list(picture_dir_path)
        file_path = files.pop(0)
        logger.info(f'Updating backgrounds to new file path {file_path}')
        system(f'gsettings set org.gnome.desktop.background picture-uri-dark file://{file_path}')
        system(f'gsettings set org.gnome.desktop.background picture-uri file://{file_path}')
        system(f'gsettings set org.gnome.desktop.screensaver picture-uri file://{file_path}')
        sleep(args.wait_interval)

if __name__ == '__main__':
    main()