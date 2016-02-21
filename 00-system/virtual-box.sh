#!/bin/bash

if ! $(lspci | grep -q VirtualBox); then
	add_config_before "
echo 'deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib' | sudo tee /etc/apt/sources.list.d/virtualbox.list
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
"
	package "linux-headers-`uname -r`"
	package "virtualbox-4.2"
	script_after "
sudo usermod -a -G vboxusers $USER
"
else
	printWarn "Could not register VirtualBox because this is a VirtualBox guest machine."
fi

