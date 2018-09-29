#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# Chrome
deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# Chromium
snap chromium

# Opera
snap opera
