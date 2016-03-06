#!/bin/bash -e

rm -rf "/tmp/wrk"
mkdir -p /tmp/wrk
trap "rm -rf /tmp/wrk" EXIT

wget "https://github.com/wg/wrk/archive/master.zip" -LO /tmp/wrk/wrk.zip
cd /tmp/wrk
unzip wrk.zip
cd wrk-master
make

# move the executable to somewhere in your PATH
sudo cp -f /tmp/wrk/wrk-master/wrk /usr/local/bin/wrk

echo "Installed wrk performance tool"
