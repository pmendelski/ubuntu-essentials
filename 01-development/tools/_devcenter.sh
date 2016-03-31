#!/bin/bash -e

# Cassandra Viewer
# Site: http://www.planetcassandra.org/devcenter/
# http://downloads.datastax.com/devcenter/DevCenter-1.5.0-linux-gtk-x86_64.tar.gz

# Build download url
declare -r version="$(curl -L http://downloads.datastax.com/devcenter | grep -Po "DevCenter-\d+.\d+.\d+-linux-gtk-x86.tar.gz" | tail -n 1 | grep -Po "\d.\d.\d")"
declare -r url="http://downloads.datastax.com/devcenter/DevCenter-${version}-linux-gtk-x86_64.tar.gz"

# Fetch and extract
rm -rf "/tmp/devcenter"
mkdir -p /tmp/devcenter
trap "rm -rf /tmp/devcenter" EXIT
wget "$url" -LO /tmp/devcenter/devcenter.tar.gz
tar -zxf "/tmp/devcenter/devcenter.tar.gz" -C "/tmp/devcenter"

# move the executable to somewhere in your PATH
# sudo cp -f /tmp/wrk2/wrk2-master/wrk /usr/local/bin/wrk2

echo "Installed cassandra devcenter v$version from $url"
