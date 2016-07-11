#!/usr/bin/env python

# Remove first 5 or so seconds from video
# .. since its usually just some UFC promo

import argparse

from moviepy.editor import VideoFileClip as vfc

def parse():
    p = argparse.ArgumentParser(description='Remove first few seconds from video file')
    p.add_argument('video_file', help='Path to video file')
    p.add_argument('-s', '--start', type=int, default=6, help='Start new video at')
    p.add_argument('-o', '--output', help='New output file')
    return p.parse_args()

args = parse()

clip = vfc(args.video_file)
sub = clip.subclip(args.start)
if args.output is None:
    file_name = '.'.join(i for i in args.video_file.split('.')[0::-1])
    args.output = '%s-edited.mp4' % file_name
sub.write_videofile(args.output)
