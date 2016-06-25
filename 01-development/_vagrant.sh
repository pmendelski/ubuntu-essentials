#!/bin/bash -e

# Build download url
declare -r version="$(curl -L https://releases.hashicorp.com/vagrant/ | grep vagrant | head -n 1 | grep -Po '\d+.\d+.\d+' | head -n 1)"
declare -r url="https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_x86_64.deb"

# Fetch and install
rm -rf "/tmp/vagrant_${version}*"
trap "rm -rf /tmp/vagrant_${version}_x86_64.deb" EXIT
wget -LP /tmp "$url"
sudo dpkg -i /tmp/vagrant_${version}_x86_64.deb

echo "Vagrant v${version} installed"
