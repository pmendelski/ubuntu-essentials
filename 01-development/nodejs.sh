#!/bin/bash

repository "ppa:chris-lea/node.js"
package "nodejs"
package "npm"

# http://stackoverflow.com/a/14914716/2284884
script_after	"
mkdir -p ~/tmp
sudo mkdir -p /usr/local/lib/node_modules
sudo ln -sf /usr/bin/nodejs /usr/local/bin/node
[ -f ~/.npm ] && sudo chown -R $USER ~/.npm
[ -f /usr/local/lib/node_modules ] && sudo chown -R $USER /usr/local/lib/node_modules
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
"

# https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers
script_after "echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p"

