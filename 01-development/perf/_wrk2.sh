#!/bin/bash -e

rm -rf "/tmp/wrk2"
mkdir -p /tmp/wrk2
trap "rm -rf /tmp/wrk2" EXIT

wget "https://github.com/giltene/wrk2/archive/master.zip" -LO /tmp/wrk2/wrk2.zip
cd /tmp/wrk2
unzip wrk2.zip
cd wrk2-master
make

# move the executable to somewhere in your PATH
sudo cp -f /tmp/wrk2/wrk2-master/wrk /usr/local/bin/wrk2

echo "Installed wrk2 performance tool"
