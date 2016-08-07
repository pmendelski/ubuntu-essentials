#!/bin/bash

script_before "
. /etc/lsb-release
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo 'deb http://repo.mongodb.org/apt/ubuntu $(lsb_release -sc)/mongodb-org/3.2 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
"
package "mongodb-org"
