#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../../utils/install.sh

# MongoDb Client: robomongo
# Site: https://robomongo.org

installRobomongo() {
  local -r downloadUrl="$(curl curl -s "https://robomongo.org/download" | grep -oP "https://download.robomongo.org/[^\"]+linux-x86_64[^\"]*\.tar\.gz" | head -n 1)"
  installFromUrl "$downloadUrl" "/opt/robomongo"
  download "https://robomongo.org/static/robomongo-128x128-129df2f1.png" "/opt/robomongo/robomongo.png"
  localBin /opt/robomongo/bin/robo3t robomongo
  desktopEntry "robomongo" \
    "[Desktop Entry]" \
    "Type=Application" \
    "Encoding=UTF-8" \
    "Name=Robomongo" \
    "Icon=/opt/robomongo/robomongo.png" \
    "Comment=MongoDB GUI Client" \
    "Exec=robomongo" \
    "Terminal=false" \
    "Categories=Network;IDE;"
  echo "Installed robomongo from $downloadUrl"
}

installRobomongo
