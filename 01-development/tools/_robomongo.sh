#!/bin/bash

# MongoDb Client: robomongo
# Site: https://robomongo.org

# Build download url
declare -r version="0.9.0-rc7"
declare -r url="https://download.robomongo.org/${version}/linux/"
declare -r package="robomongo-${version}-linux-x86_64-2b7a8ca.tar.gz"
declare -r tmpdir="/tmp/robomongo"

# Fetch and extract
rm -rf "$tmpdir"
mkdir -p "$tmpdir"
trap "rm -rf $tmpdir" EXIT
wget "$url/$package" -LP "$tmpdir"
tar -zxf "$tmpdir/$package" -C "$tmpdir"

# move the executable to somewhere in your PATH
sudo rm -fr "/opt/robomongo"
sudo mv -fT "$tmpdir/${package%.tar.gz}" "/opt/robomongo"

echo "Installed robomongo v$version from $url/$package"
