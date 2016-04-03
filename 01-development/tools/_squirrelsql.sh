#!/bin/bash -e

# SQuirreL SQL
# http://squirrel-sql.sourceforge.net/

# Build download url
declare -r version="$(curl -kL https://sourceforge.net/projects/squirrel-sql/files/1-stable/ | grep -Po "stable/\d+\.\d+\.\d+-plainzip" | head -n 1 | grep -Po "\d.\d.\d")"
declare -r shortVersion="${version%.0}"
declare -r shorterVersion="${shortVersion%.0}"
declare -r package="squirrelsql-${shorterVersion}-optional.zip"
declare -r url="http://downloads.sourceforge.net/project/squirrel-sql/1-stable/${version}-plainzip/${package}?ts=$(date +%s)&use_mirror=tenet"
declare -r tmpdir="/tmp/squirrelsql"

# Fetch and extract
rm -rf "$tmpdir"
mkdir -p "$tmpdir"
trap "rm -rf $tmpdir" EXIT
wget "$url" -LP "$tmpdir"
unzip "$tmpdir/$package" -d "$tmpdir"

# move the executable to somewhere in your PATH
sudo rm -fr "/opt/squirrelsql"
sudo mv -fT "$tmpdir/${package%.zip}" "/opt/squirrelsql"

echo "Installed squirrelsql v$version from $url"
