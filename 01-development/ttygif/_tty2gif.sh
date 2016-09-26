#!/bin/bash -e

rm -rf "/tmp/ttygif"
mkdir -p /tmp/ttygif
trap "rm -rf /tmp/ttygif" EXIT

wget "https://github.com/icholy/ttygif/archive/master.zip" -LO /tmp/ttygif/ttygif.zip
cd /tmp/ttygif
unzip ttygif.zip
cd ttygif-master
make

sudo make install

echo "Installed ttygif tool"
