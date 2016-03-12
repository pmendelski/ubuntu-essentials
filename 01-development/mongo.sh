#!/bin/bash

script_before "
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/10gen.list
"
package "mongodb-10gen"

script_after "
sudo update-rc.d -f mongodb remove
"
