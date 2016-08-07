#!/bin/bash

if ! $(lspci | grep -q VirtualBox); then
    # if not in VirtualBox session
    script_before "
    echo 'deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib' | sudo tee /etc/apt/sources.list.d/virtualbox.list
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    "
    # Find version
    declare -r virtualbox_version="$(curl -L https://www.virtualbox.org/wiki/Linux_Downloads | grep "sudo apt-get install virtualbox-" | head -n 1 | grep -Po "\d+(.\d+)?(.\d+)?")"
    package "linux-headers-`uname -r`"
    package "virtualbox-$virtualbox_version"
    script_after "
    sudo usermod -a -G vboxusers $USER
    "
else
    # if in virtual box session
    printWarn "Could not register VirtualBox because this is a VirtualBox guest machine."
fi
