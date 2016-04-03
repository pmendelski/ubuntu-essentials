#!/bin/bash

# Source: https://www.dropbox.com/pl/install
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
script_after "~/.dropbox-dist/dropboxd"
