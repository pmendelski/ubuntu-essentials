#!/bin/bash -e

declare -r version="$(curl -LIs "https://github.com/ericchiang/pup/releases/latest" | grep Location | tail -n 1 | sed -n "s|Location: .\+/tag/\([^/]\+\)|\1|p" | tr -d "\r")"
declare -r url="https://github.com/ericchiang/pup/releases/download/$version/pup_${version}_linux_amd64.zip"

rm -rf "/tmp/pup"
mkdir -p /tmp/pup
trap "rm -rf /tmp/pup" EXIT

wget "$url" -LO /tmp/pup/pup.zip
cd /tmp/pup
unzip pup.zip

# move the executable to somewhere in your PATH
sudo cp -f /tmp/pup/pup /usr/local/bin/pup

echo "Installed pup $version html parsing tool"
pup --help
