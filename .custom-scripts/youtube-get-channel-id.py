import argparse
import requests


def parse_args():
    p = argparse.ArgumentParser(description='Get channel ID info for a youtube user')
    p.add_argument('youtube_api_key', help='Youtube API Key to Use')
    p.add_argument('youtube_username', help='Youtube username')
    return p.parse_args()

def main():
    args = parse_args()
    url = 'https://www.googleapis.com/youtube/v3/channels?key=%s&forUsername=%s&part=id' % \
            (args.youtube_api_key, args.youtube_username)
    r = requests.get(url)
    print "Status code of requests:", r.status_code
    print "Data\n", r.text

if __name__ == '__main__':
    main()
