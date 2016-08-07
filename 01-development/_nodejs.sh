#!/bin/bash

git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
. ~/.nvm/nvm.sh
nvm install node
npm install -g http-server gulp eslint npm-check-updates
