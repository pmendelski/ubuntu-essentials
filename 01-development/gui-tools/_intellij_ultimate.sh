#!/bin/bash -e

declare -r url=$(curl -L "https://data.services.jetbrains.com/products/releases?code=IIU%2CIIC&latest=true&type=release" | jq -r .IIU[0].downloads.linux.link)
declare -r fileName=$(echo "$url" | grep -o "[^/]\+$")
declare -r version=$(echo "$fileName" | grep -o "[^/]\+$" | grep -Po "\d+(\.\d+){0,2}")

# Fetch and extract
rm -rf "/tmp/idea-IU-${version}"
trap "rm -rf /tmp/idea-IU-${version}; " EXIT
mkdir -p "/tmp/idea-IU-${version}"
wget -LP "/tmp/idea-IU-${version}" "$url"
tar -zxf "/tmp/idea-IU-${version}/$fileName" -C "/tmp/idea-IU-${version}"
rm -f "/tmp/idea-IU-${version}/$fileName"
declare -r dirname="$(find /tmp/idea-IU-${version} -type d -mindepth 1 -maxdepth 1 2>/dev/null | head -n 1)"
sudo mkdir -p "/opt/idea"
sudo rm -rf "/opt/idea/idea-IU-${version}"
sudo mv "$dirname" "/opt/idea/idea-IU-${version}"

# Change vmoptions
# cp "/opt/idea/idea-IU-${version}/bin/idea64.vmoptions" "/opt/idea/idea-IU-${version}/bin/idea64.vmoptions.bak"
# cat "/opt/idea/idea-IU-${version}/bin/idea64.vmoptions.bak" | sed \
#     -e "s/\(-Xms\).*/\11g/" \
#     -e "s/\(-Xmx\).*/\12g/" \
#     -e "s/\(-XX:ReservedCodeCacheSize=\).*/\1512m/" \
#     > "/opt/idea/idea-IU-${version}/bin/idea64.vmoptions"

# Remove previos desktop entry if exists
# sudo rm -f /usr/share/applications/jetbrains-*.desktop

echo "Intellij IDEA v${version} installed in /opt/idea/idea-IU-${version}"
