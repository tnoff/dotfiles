#!/usr/bin/env python
# Use tracks file to name files after split
# File format:
# <track-name> <time-start>

# time in [<hour>:]<minute>:<second>

import argparse

from moviepy.editor import AudioFileClip
import mutagen

def parse_args():
    parser = argparse.ArgumentParser(description='Strip audio files into seperate subclips')
    parser.add_argument('audio_file', help='Path to audio file')
    parser.add_argument('track_info', help='Track file to use')
    parser.add_argument('--encoding', default="utf-8",
                        help="Encoding used for track info file")
    return parser.parse_args()

def get_number_digits(number):
    count = 1
    checker = 10
    while True:
        if checker > number:
            return count
        count += 1
        checker *= 10

def get_time(timestamp):
    total = 0
    seconds = 1
    for t in timestamp.split(':')[::-1]:
        total += (int(t) * seconds)
        seconds *= 60
    return total

def main():
    args = parse_args()
    audio_clip = AudioFileClip(args.audio_file)

    with open(args.track_info, 'r') as read:
        data = read.read()
        data = data.rstrip('\n')

    track_data = []
    for line in data.split('\n'):
        # Split by space, assume time is last bit
        split = line.split(' ')
        # Make sure no trailing whitespaces, or other weirdness
        split = [i for i in split if i != '']
        time = split[-1]
        # assume name is other part of split
        name = ' '.join(i for i in split[:-1]).decode(args.encoding)
        track_data.append((name, time))

    number_tracks = len(track_data)
    # get number digits, use that for 0 prefix cutoff
    # for example, 15 tracks, 10 would be cutoff to adding "0" to
    # .. to start of track names
    num_digits = get_number_digits(number_tracks)
    prefix_cutoff = 10 ** (num_digits - 1)

    for (count, track) in enumerate(track_data):
        # start is time in current track
        # end is time in next track
        start = get_time(track[1])
        try:
            end = get_time(track_data[count + 1][1])
        except IndexError:
            end = None
        # make prefix for filename
        name = '%s-%s.mp3' % (count + 1, track[0])
        if (count + 1) < prefix_cutoff:
            name = '%s%s' % (''.join('0' for _ in range(num_digits - 1)), name)
        subclip = audio_clip.subclip(t_start=start, t_end=end)
        file_name = name.replace('/', '_')
        subclip.write_audiofile(file_name)
        tags = mutagen.File(file_name, easy=True)
        tags['tracknumber'] = '%s/%s' % (count + 1, number_tracks)
        tags['title'] = track[0]
        tags.save()

if __name__ == '__main__':
    main()
