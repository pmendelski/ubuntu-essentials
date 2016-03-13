#!/bin/bash

# if in VirtualBox session
if ! $(lspci | grep -q VirtualBox); then
script_after "
wget -qO- https://get.docker.com/ | sh
sudo apt-get install apparmor
sudo service docker restart
sudo usermod -a -G docker $USER
"

# if not in VirtualBox session
else
    printWarn "Could not install docker in VirtualBox"
fi
