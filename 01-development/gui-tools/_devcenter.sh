#!/bin/bash -e

# Cassandra Client: DevCenter
# Site: http://www.planetcassandra.org/devcenter/
# http://downloads.datastax.com/devcenter/DevCenter-1.5.0-linux-gtk-x86_64.tar.gz

# Build download url
declare -r url="http://downloads.datastax.com/devcenter"
declare -r version="$(curl -L $url | grep -Po "DevCenter-\d+.\d+.\d+-linux-gtk-x86_64.tar.gz" | tail -n 1 | grep -Po "\d.\d.\d")"
declare -r package="DevCenter-${version}-linux-gtk-x86_64.tar.gz"
declare -r tmpdir="/tmp/devcenter"

# Fetch and extract
rm -rf "$tmpdir"
mkdir -p "$tmpdir"
trap "rm -rf $tmpdir" EXIT
wget "$url/$package" -LP "$tmpdir"
tar -zxf "$tmpdir/$package" -C "$tmpdir"

# move the executable to somewhere in your PATH
sudo rm -fr "/opt/devcenter"
sudo mv -fT "$tmpdir/DevCenter" "/opt/devcenter"

echo "Installed cassandra devcenter v$version from $url/$package"
