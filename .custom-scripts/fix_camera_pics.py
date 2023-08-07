#!/usr/bin/env python

from argparse import ArgumentParser
import re
from pathlib import Path

SUPPORTED_FILES = [
    '.jpg',
    '.png',
    '.mp4',
]

FILE_NAME_REGEX = r'^(IMG_|VID_|PXL_)?(?P<year>\d{4})(?P<month>\d{2})(?P<day>\d{2})_(?P<hour>\d{2})(?P<minute>\d{2})' \
                  '(?P<second>\d{2})(?P<microsecond>\d{3})?(_MP)?(_HDR)?(_PORTRAIT)?(?P<suffix>.*)$'

def parse_args():
    parser = ArgumentParser(description='Fix camera pictures names')
    input_dir = parser.add_argument('input_dir', help='Directory with files')
    return parser.parse_args()

def main():
    args = parse_args()
    input_path = Path(args.input_dir)

    rename_pairs = []

    for file_name in Path(input_path).glob('*'):
        if not file_name.is_file():
            continue
        if file_name.suffix not in SUPPORTED_FILES:
            continue

        base_path = file_name.absolute().parent
        full_path = base_path / file_name.name

        match = re.match(FILE_NAME_REGEX, file_name.name)
        if not match:
            print(f'File name did not match regex {file_name.name}')
            continue

        new_name = f'{match.group("year")}-{match.group("month")}-{match.group("day")} ' \
                   f'{match.group("hour")}-{match.group("minute")}-{match.group("second")}'
        if match.group("microsecond"):
            new_name = f'{new_name},{match.group("microsecond")}'
        new_name = f'{new_name}{match.group("suffix")}'
        new_path = base_path / new_name

        print(f'Renaming {full_path} -> {new_path}')
        rename_pairs.append([full_path, new_path])

    check = input('Continue [Y/y]')

    if check.lower().strip() == 'y':
        print('')
        for pair in rename_pairs:
            pair[0].replace(pair[1])


if __name__ == '__main__':
    main()
