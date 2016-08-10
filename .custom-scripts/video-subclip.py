#!/usr/bin/env python

# Create a video file subclip from a video file

import argparse
import os

from moviepy.editor import VideoFileClip as vfc

def parse():
    p = argparse.ArgumentParser(description='Create a video subclip from a video file')
    p.add_argument('video_file', help='Path to video file')
    p.add_argument('-s', '--start', type=int, default=0, help='Time to start subclip')
    p.add_argument('-e', '--end', type=int, help='Time to end subclip')
    p.add_argument('-o', '--output', help='Name of new file')
    return p.parse_args()

args = parse()

clip = vfc(args.video_file)

if args.end is None:
    sub = clip.subclip(args.start)
else:
    sub = clip.subclip(args.start, args.end)

if args.output is None:
    args.output = '%s-edited.mp4' % os.path.splitext(args.video_file)[0]
sub.write_videofile(args.output)
