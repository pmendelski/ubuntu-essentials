#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../../utils/install.sh

installWrk() {
  local -r tmp="$(createTmpDir)"
  download "https://github.com/wg/wrk/archive/master.zip" "$tmp/wrk.zip"
  extract "$tmp/wrk.zip" "$tmp/wrk"
  cd "$tmp/wrk"
  make
  sudo cp -f "$tmp/wrk/wrk" /usr/local/bin/wrk
  cd -
  echo "Installed wrk performance tool"
}

installWrk2() {
  local -r tmp="$(createTmpDir)"
  package libssl-dev
  package libz-dev
  download "https://github.com/giltene/wrk2/archive/master.zip" "$tmp/wrk2.zip"
  extract "$tmp/wrk2.zip" "$tmp/wrk2"
  cd "$tmp/wrk2"
  make
  sudo cp -f "$tmp/wrk2/wrk" /usr/local/bin/wrk2
  cd -
  echo "Installed wrk2 performance tool"
}

installWrk
installWrk2
