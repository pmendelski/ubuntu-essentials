#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../../utils/install.sh

installVirtualBox() {
  printInfo "Installing VirtualBox"
  local -r version="$(curl -sL https://www.virtualbox.org/wiki/Linux_Downloads | grep "sudo apt-get install virtualbox-" | head -n 1 | grep -Po "\d+(.\d+)?(.\d+)?")"
  aptKey "https://www.virtualbox.org/download/oracle_vbox_2016.asc"
  aptKey "https://www.virtualbox.org/download/oracle_vbox.asc"
  aptSource "virtualbox" "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib"
  package "linux-headers-`uname -r`"
  package "virtualbox-$version"
  sudo usermod -a -G vboxusers $USER
  vboxmanage -v
}

installVirtualBoxExtPack() {
  printInfo "Installing VirtualBox Extension Pack"
  local -r version="$(vboxmanage -v | grep -oP "\d+\.\d+\.\d+")"
  local -r file="Oracle_VM_VirtualBox_Extension_Pack-$version.vbox-extpack"
  local -r tmp="$(createTmpDir vboxext)"
  download "http://download.virtualbox.org/virtualbox/$version/$file" -O "$tmp/$file"
  echo y | sudo vboxmanage extpack install "$tmp/$file" --replace
  removeTmpDir "$tmp"
}

if ! $(lspci | grep -q VirtualBox); then
  installVirtualBox
  installVirtualBoxExtPack
else
  printWarn "Could not install VirtualBox in a VirtualBox guest machine."
fi
