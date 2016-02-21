#!/bin/bash

# docker

if ! $(lspci | grep -q VirtualBox); then
	script_after	"
wget -qO- https://get.docker.com/ | sh
sudo apt-get install apparmor
sudo service docker restart
"
else
	printWarn "Could not install docker in VirtualBox"
fi

