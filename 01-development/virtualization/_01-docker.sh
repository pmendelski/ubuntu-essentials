#!/bin/bash

if ! $(lspci | grep -q VirtualBox); then
    # if not in VirtualBox session
    wget -qO- https://get.docker.com/ | sh
    sudo apt-get install apparmor
    sudo service docker restart
    sudo usermod -a -G docker $USER
else
    # if in VirtualBox session
    printWarn "Could not install docker in VirtualBox"
fi
