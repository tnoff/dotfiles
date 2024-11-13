#!/usr/bin/env python

from argparse import ArgumentParser
from datetime import date, timedelta
from os import environ
from os.path import expanduser

from pathlib import Path

HOME_PATH = Path(expanduser('~'))
NOTE_FOLDER_DEFAULT = HOME_PATH / 'Notes'
DATE_FORMAT = '%Y-%m-%d'

NOTES_TEMPLATE = '# {today}\n\n## Stuff Completed\n\n## Mood Notes\n\n- Mood: ?/10\n- Day: ?/10\n- Mental Health: ?/10\n\n## TODOs/Followups\n'

def parse_args():
    parser = ArgumentParser(description='Create Note Folders')
    parser.add_argument('-p', '--note_folder_path', default=str(NOTE_FOLDER_DEFAULT), help='Path of note folder')
    return parser.parse_args()

def main():
    args = parse_args()
    note_path = Path(args.note_folder_path)
    if not environ.get('ENABLE_NOTE_FOLDER', False):
        return

    # Get start of current week and the end of the current week
    start_of_week = date.today()
    end_of_week = date.today()
    while start_of_week.weekday() > 0:
        start_of_week = start_of_week - timedelta(days=1)
    
    while end_of_week.weekday() < 6:
        end_of_week = end_of_week + timedelta(days=1)

    # Create week folder if it doesnt exist
    week_folder = note_path / f'{start_of_week.strftime(DATE_FORMAT)}_{end_of_week.strftime(DATE_FORMAT)}'
    week_folder.mkdir(exist_ok=True)

    today = date.today()
    today_file = week_folder / f'{today.strftime(DATE_FORMAT)}.md'

    if not today_file.exists():
        text = NOTES_TEMPLATE.format(today=today.strftime(DATE_FORMAT))
        today_file.write_text(text)
    print(str(today_file))

if __name__ == '__main__':
    main()
