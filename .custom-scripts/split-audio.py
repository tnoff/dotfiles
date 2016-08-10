#!/usr/bin/env python
import argparse
import sys

from moviepy.editor import AudioFileClip

def parse_args():
    parser = argparse.ArgumentParser(description='Strip audio files into seperate subclips')
    parser.add_argument('audio_file', help='Path to audio file')
    parser.add_argument('subclip', nargs='+',
                        help='Time of track start <minute>:<second> format'\
                             ' DO NOT INCLUDE 0:0 START')
    parser.add_argument('--output-index', type=int, default=1,
                        help='Start output index as X')
    return parser.parse_args()

def write_to_mediafile(subclip, output_index, audio_file_name):
    # this shit does assume less than 100, but downloading that much
    # seems extremely fucking unlikely right meow
    if output_index < 10:
        output_index_string = '0%s' % output_index
    else:
        output_index_string = '%s' % output_index
    subclip.write_audiofile('%s-%s' % (output_index_string, audio_file_name))

def main():
    args = parse_args()

    output_index = args.output_index
    audio_clip = AudioFileClip(args.audio_file)

    start_at = 0

    for sub in args.subclip:
        tiago_splitter = sub.split(':')
        try:
            minutes = int(tiago_splitter[0])
            seconds = int(tiago_splitter[1]) + (minutes * 60)
        except IndexError:
            print 'Invalid subclip value %s' % sub
            sys.exit(-1)
        print 'Output index:', output_index, 'Starting second:',\
               start_at, 'Ending second:', seconds
        subclip = audio_clip.subclip(start_at, seconds)
        write_to_mediafile(subclip, output_index,
                           args.audio_file)
        start_at = seconds
        output_index += 1
    print 'Output index:', output_index, 'Starting second:', start_at
    subclip = audio_clip.subclip(start_at)
    write_to_mediafile(subclip, output_index,
                       args.audio_file)
    sys.exit(0)

if __name__ == '__main__':
    main()
