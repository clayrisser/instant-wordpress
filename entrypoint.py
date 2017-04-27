#!/usr/bin/env python

import os
import time
import subprocess
import signal
import requests
from functools import partial
import sys

def main():
    server = subprocess.Popen(['docker-entrypoint.sh apache2-foreground'], shell=True)
    signal.signal(signal.SIGINT, partial(signal_handler, server))
    install()
    server.wait()

def signal_handler(server, signal_int, frame):
    server.send_signal(signal.SIGTERM)

def install():
    page = ''
    while page == '':
        try:
            page = requests.get('http://localhost')
        except:
            continue
            time.sleep(5)
    time.sleep(5)
    os.system('''wp --allow-root core install \
    --url=''' + os.environ['WORDPRESS_URL'] + ''' \
    --title="''' + os.environ['WORDPRESS_TITLE'] + '''" \
    --admin_user=''' + os.environ['WORDPRESS_ADMIN_USER'] + ''' \
    --admin_email=''' + os.environ['WORDPRESS_ADMIN_EMAIL'] + ''' \
    --admin_password=''' + os.environ['WORDPRESS_ADMIN_PASSWORD'])

main()
