#!/bin/bash

# if in VirtualBox session
if ! $(lspci | grep -q VirtualBox); then

# Find version
declare -r version="$(curl -L https://www.virtualbox.org/wiki/Linux_Downloads | grep "sudo apt-get install virtualbox-" | head -n 1 | grep -Po "\d+(.\d+)?(.\d+)?")"
script_before "
echo 'deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib' | sudo tee /etc/apt/sources.list.d/virtualbox.list
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
"
package "linux-headers-`uname -r`"
package "virtualbox-$version"
script_after "
sudo usermod -a -G vboxusers $USER
"

# if not in virtual box session
else
    printWarn "Could not register VirtualBox because this is a VirtualBox guest machine."
fi
