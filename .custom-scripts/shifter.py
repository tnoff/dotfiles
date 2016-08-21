#!/usr/bin/env python

import os
import random
import time

def main():
    home_directory = os.path.expanduser('~')
    picture_directory = os.path.join(home_directory, 'Pictures', 'Wallpapers')
    sleep_seconds = 300

    files = os.listdir(picture_directory)
    while True:
        if len(files) == 0:
            files = os.listdir(picture_directory)
        for _ in range(100):
            random.shuffle(files)
        file_name = os.path.join(picture_directory, files.pop(0))
        os.system('gsettings set org.gnome.desktop.background picture-uri "file:///%s"' % file_name)
        time.sleep(sleep_seconds)

if __name__ == '__main__':
    main()
