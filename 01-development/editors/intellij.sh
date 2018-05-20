#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../../utils/install.sh

installIntelliJ() {
  declare -r name="$1"
  declare -r downloadUrl="$2"
  installFromUrl "$downloadUrl" "/opt/idea/$name"
  localBin "/opt/idea/$name/bin/idea.sh" "$name"
  desktopEntry "$name" \
    "[Desktop Entry]" \
    "Type=Application" \
    "Encoding=UTF-8" \
    "Name=IntelliJ - $name" \
    "Icon=/opt/idea/$name/bin/idea.png" \
    "Comment=IntelliJ Idea - $name" \
    "Exec=$name" \
    "Terminal=false" \
    "Categories=IDE;"
  echo "IntelliJ ($name) installed from ${downloadUrl}"
}

installIntelliJUltimate() {
  local -r downloadUrl="$(curl -s "https://data.services.jetbrains.com/products/releases?code=IIU%2CIIC&latest=true&type=release" | jq -r '.IIU[0].downloads.linux.link')"
  installIntelliJ "idea-ultimate" "$downloadUrl"
}

installIntelliJCommunity() {
  local -r downloadUrl="$(curl -s "https://data.services.jetbrains.com/products/releases?code=IIU%2CIIC&latest=true&type=release" | jq -r '.IIC[0].downloads.linux.link')"
  installIntelliJ "idea" "$downloadUrl"
}

installIntelliJUltimate
installIntelliJCommunity
