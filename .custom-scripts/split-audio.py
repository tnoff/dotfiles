#!/usr/bin/env python
# Use tracks file to name files after split
# File format:
# <track-name> <time-start>
# time in [<hour>:]<minute>:<second>[,<miliseconds>]

# OPTIONAL
# First line in track info can contain artist,album,date info
# info in "INFO: <artist> /// <album> /// <date>"

import argparse
import re
import sys

from moviepy.editor import AudioFileClip
import mutagen


LINE_REGEX = '^(.*) ([0-9:,]+)$'
TIME_REGEX = '([0-9]+:)?([0-9]+):([0-9]+)(,[0-9]+)?$'
INFO_REGEX = '^INFO: (.*) /// (.*) /// (.*)'

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
            break
        count += 1
        checker *= 10
    return count

def get_time(timestamp):
    time_group = re.search(TIME_REGEX, timestamp)
    try:
        hour = time_group.group(1)
        minute = time_group.group(2)
        second = time_group.group(3)
        milisecond = time_group.group(4)
    except AttributeError:
        print("Invalid timestamp:%s" % timestamp)
        sys.exit(1)
    total = 0
    if hour:
        total += (int(hour.replace(':', '')) * 60 * 60)
    total += (int(minute) * 60)
    total += int(second)
    if milisecond:
        mili = int(milisecond.replace(',', ''))
        digits = get_number_digits(mili)
        total += (mili / (10.0 ** digits))
    return total

def main():
    args = parse_args()
    audio_clip = AudioFileClip(args.audio_file)

    with open(args.track_info, 'r') as read:
        data = read.read()
        data = data.rstrip('\n')

    base_tags = {}

    data_lines = data.split('\n')
    start_count = 0
    if data_lines[0].startswith('INFO'):
        info = re.search(INFO_REGEX, data_lines[0])
        base_tags['artist'] = info.group(1)
        base_tags['album'] = info.group(2)
        base_tags['date'] = info.group(3)
        start_count += 1

    track_data = []
    for line in data_lines[start_count:]:
        line = line.strip(' ')
        groups = re.search(LINE_REGEX, line)
        if not groups:
            sys.exit("Invalid line %s" % line)
        time = groups.group(2)
        name = groups.group(1)
        track_data.append((name, time))

    number_tracks = len(track_data)
    # get number digits, use that for 0 prefix cutoff
    # for example, 15 tracks, 10 would be cutoff to adding "0" to
    # .. to start of track names
    num_digits = get_number_digits(number_tracks)
    prefix_cutoff = 10 ** (num_digits - 1)
    # Make sure at least two digits used
    if prefix_cutoff == 1:
        prefix_cutoff = 10
        num_digits = 2


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
        if base_tags:
            tags['artist'] = base_tags['artist']
            tags['albumartist'] = base_tags['artist']
            tags['album'] = base_tags['album']
            tags['date'] = base_tags['date']
        tags.save()

if __name__ == '__main__':
    main()
