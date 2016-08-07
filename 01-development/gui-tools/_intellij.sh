#!/bin/bash -e

declare -r url=$(curl -L "https://data.services.jetbrains.com/products/releases?code=IIU%2CIIC&latest=true&type=release" | jq -r .IIC[0].downloads.linux.link
declare -r fileName=$(echo "$url" | grep -o "[^/]\+$")
declare -r version=$(echo "$fileName" | grep -o "[^/]\+$" | grep -Po "\d+(\.\d+){0,2}")

# Fetch and extract
rm -rf "/tmp/idea-IC-${version}"
trap "rm -rf /tmp/idea-IC-${version}; " EXIT
mkdir -p "/tmp/idea-IC-${version}"
wget -LP "/tmp/idea-IC-${version}" "$url"
tar -zxf "/tmp/idea-IC-${version}/$fileName" -C "/tmp/idea-IC-${version}"
rm -f "/tmp/idea-IC-${version}/$fileName"
declare -r dirname="$(find /tmp/idea-IC-${version} -type d -mindepth 1 -maxdepth 1 2>/dev/null | head -n 1)"
sudo mkdir -p "/opt/idea"
sudo rm -rf "/opt/idea/idea-IC-${version}"
sudo mv "$dirname" "/opt/idea/idea-IC-${version}"

# Change vmoptions
# cp "/opt/idea/idea-IC-${version}/bin/idea64.vmoptions" "/opt/idea/idea-IC-${version}/bin/idea64.vmoptions.bak"
# cat "/opt/idea/idea-IC-${version}/bin/idea64.vmoptions.bak" | sed \
#     -e "s/\(-Xms\).*/\11g/" \
#     -e "s/\(-Xmx\).*/\12g/" \
#     -e "s/\(-XX:ReservedCodeCacheSize=\).*/\1512m/" \
#     > "/opt/idea/idea-IC-${version}/bin/idea64.vmoptions"

# Remove previos desktop entry if exists
# sudo rm -f /usr/share/applications/jetbrains-*.desktop

echo "Intellij IDEA v${version} installed in /opt/idea/idea-IC-${version}"
