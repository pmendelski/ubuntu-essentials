#!/bin/bash -e

# DbVisualizer
# Site: https://www.dbvis.com/download/
# https://www.dbvis.com/product_download/dbvis-9.2.15/media/dbvis_linux_9_2_15.deb

# Build download url
declare -r version="$(curl -kL https://www.dbvis.com/download | grep -Po "dbvis_linux_\d+_\d+_\d+.deb" | tail -n 1 | grep -Po "\d.\d.\d")"
declare -r url="https://www.dbvis.com/product_download/dbvis-${version//_/.}/media"
declare -r package="dbvis_linux_${version}.deb"
declare -r tmpdir="/tmp/dbvis"

# Fetch and extract
rm -rf "$tmpdir"
mkdir -p "$tmpdir"
trap "rm -rf $tmpdir" EXIT
wget "$url/$package" -LP "$tmpdir"
sudo dpkg -i "$tmpdir/$package"

echo "Installed DbVisualizer v$version from $url/$package"
