#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../../utils/install.sh

installJdkFromUrl() {
  local -r url="$1"
  local -r vendor="${2:-oracle}"
  local -r file="${url##*/}"
  local -r name="${vendor}-$(echo "$file" | grep -oE "^([^-]+-[^-]+)")"
  local -r tmpdir="$(createTmpDir java)"
  cd "$tmpdir"
  wget -q --show-progress --no-check-certificate -c -O "$file" --header "Cookie: oraclelicense=accept-securebackup-cookie" "$url"
  extract "$file" "$name"
  mv "$name" "$HOME/.jdk"
  cd -
  removeTmpDir "$tmpdir"
}

installNewestOracleJdk() {
  local -r downloadPageUrl="$1";
  local -r downloadUrl="$(\
    curl -s "$downloadPageUrl" \
      | grep -oE "https?://download\.oracle\.com/[^\"]+[_-]linux[_-]x64([_-]bin)?\.tar\.gz" \
      | sort -r \
      | head -n 1 \
  )"
  installJdkFromUrl "$downloadUrl" "oracle"
}

printInfo "Install newest oracle-jdk8"
installNewestOracleJdk "http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"

printInfo "Install newest oracle-jdk10"
installNewestOracleJdk "http://www.oracle.com/technetwork/java/javase/downloads/jdk10-downloads-4416644.html"
