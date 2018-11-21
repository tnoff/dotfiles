#!/usr/bin/env python

import argparse
import os
import random
import sys
import time


HOME = os.path.expanduser("~")
PATH = os.path.join(HOME, '.alarm-sounds')

def parse_args():
    p = argparse.ArgumentParser(description="Timer")
    p.add_argument('--minutes', type=int, required=True, help="Minutes")
    p.add_argument('--seconds', type=int, default=0, help="Seconds")
    return p.parse_args()

def main():
    args = parse_args()
    total_seconds = args.minutes * 60 + args.seconds

    files = ['%s/%s' % (PATH, file_name) for file_name in os.listdir(PATH)]
    file_name = random.choice(files)
    while True:
        if total_seconds <= 0:
            command = 'vlc "%s"' % (file_name)
            os.system(command)
            break
        sys.stdout.write('Time left to wait %sm %ss \r' % (total_seconds / 60, total_seconds % 60))
        sys.stdout.flush()
        time.sleep(1)
        total_seconds -= 1

if __name__ == '__main__':
    main()
