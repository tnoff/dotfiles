#!/usr/bin/env python
import argparse
import os
import random

def parse_args():
    p = argparse.ArgumentParser(description="Play random media files")
    p.add_argument("file_dir", help="File Directory to play")
    return vars(p.parse_args())

def main():
    args = parse_args()
    abs_path = os.path.abspath(args["file_dir"])
    file_list = os.listdir(abs_path)
    random.shuffle(file_list)
    play_files = []
    for file_name in file_list:
        play_files.append(os.path.join(abs_path, file_name))
    command = 'vlc %s' % " ".join('"%s"' % i for i in play_files)
    print("Command:", command)
    os.system(command)

if __name__ == '__main__':
    main()
