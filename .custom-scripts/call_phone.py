#!/usr/bin/env python
import argparse
import os
import sys

from twilio.rest import Client

def parse_args():
    p = argparse.ArgumentParser(description='Twilio Call Phone')
    p.add_argument('--account-sid', help='Twilio Account SID')
    p.add_argument('--auth-token', help='Twilio Auth Token')
    p.add_argument('--call-number', help='Number to call')
    p.add_argument('--twilio-number', help='Twilio Number')

    args = vars(p.parse_args())

    # check if args in env
    if args['account_sid'] is None:
        args['account_sid'] = os.getenv('TWILIO_ACCOUNT_SID', None)
    if args['auth_token'] is None:
        args['auth_token'] = os.getenv('TWILIO_AUTH_TOKEN', None)
    if args['twilio_number'] is None:
        args['twilio_number'] = os.getenv('TWILIO_PHONE_NUMBER', None)
    if args['call_number'] is None:
        args['call_number'] = os.getenv('TWILIO_CALL_NUMBER', None)

    # check fail conditions
    if args['account_sid'] is None or args['auth_token'] is None:
        sys.exit("Account sid or auth token not given")
    if args['call_number'] is None or args['twilio_number'] is None:
        sys.exit("Call number and/or twilio number not given")

    return args

def make_call(args):

    client = Client(args['account_sid'], args['auth_token'])

    # Make the call
    call = client.calls.create(to=args['call_number'],
                               from_=args['twilio_number'],
                               url="http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient")

    print 'Call Sid:', call.sid

def main():
    args = parse_args()
    make_call(args)

if __name__ == '__main__':
    main()
