#!/usr/bin/env python

# use moviepy to create a new videofile with the given input

import argparse
import os

from moviepy.editor import VideoFileClip as vfc

def parse_args():
    p = argparse.ArgumentParser(description='Convert videofiles to a new type of media')
    p.add_argument('media_type', help='New type of media')
    p.add_argument('video_files', nargs='+', help='Video files to convert')
    return p.parse_args()

def main():
    args = parse_args()
    media = args.media_type
    if media[0] != '.':
        media = '.%s' % media

    for file_name in args.video_files:
        name = os.path.abspath(file_name)
        path, ext = os.path.splitext(name)
        print 'Converting file %s from media type %s to %s' % (path, ext, media) 
        clip = vfc(name)
        clip.write_videofile('%s%s' % (path, media))

if __name__ == '__main__':
    main()
