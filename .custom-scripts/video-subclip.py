#!/usr/bin/env python

# Create a video file subclip from a video file

import argparse
import os

from moviepy.editor import VideoFileClip as vfc

def parse():
    p = argparse.ArgumentParser(description='Create a video subclip from a video file')
    p.add_argument('video_file', help='Path to video file')
    p.add_argument('-s', '--start', help='Time to start subclip')
    p.add_argument('-e', '--end', help='Time to end subclip')
    p.add_argument('-o', '--output', help='Name of new file')
    return p.parse_args()

def main():
    args = parse()

    clip = vfc(args.video_file)

    sub = clip.subclip(t_start=args.start, t_end=args.end)

    if args.output is None:
        basename, _ = os.path.splitext(args.video_file)
        args.output = '%s-edited.mp4' % basename
    sub.write_videofile(args.output)

if __name__ == '__main__':
    main()
