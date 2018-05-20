#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../../utils/install.sh

installVagrant() {
  printInfo "Installing Vagrant"
  declare -r version="$(curl -L https://releases.hashicorp.com/vagrant/ | grep vagrant | head -n 1 | grep -Po '\d+.\d+.\d+' | head -n 1)"
  declare -r url="https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_x86_64.deb"
  deb "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_x86_64.deb"
  vagrant -v
}

if ! $(lspci | grep -q VirtualBox); then
  installVagrant
else
  printWarn "Could not install docker in VirtualBox"
fi
