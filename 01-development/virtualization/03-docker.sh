#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../../utils/install.sh

installDocker() {
  printInfo "Installing Docker"
  wget -qO- https://get.docker.com/ | sh
  sudo apt install apparmor
  sudo service docker restart
  sudo usermod -a -G docker $USER
  docker -v
}

installDockerCompose() {
  printInfo "Installing Docker Compose"
  local -r version="$(curl -s -L https://github.com/docker/compose/releases | grep docker-compose | grep -Po '\d+.\d+.\d+(?=/)' | head -n 1)"
  local -r downloadUrl="https://github.com/docker/compose/releases/download/${version}/docker-compose-$(uname -s)-$(uname -m)"
  local -r dest="/usr/local/bin/docker-compose"
  sudo rm -f "$dest"
  download "$downloadUrl" "$dest"
  sudo chmod +x "$dest"
  docker-compose -v
}

if ! $(lspci | grep -q VirtualBox); then
  installDocker
  installDockerCompose
else
  printWarn "Could not install docker in VirtualBox"
fi
