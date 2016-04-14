#!/bin/bash

# Deluge bit torrent
package "deluge"

script_before "
sudo sh -c 'echo \"deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main\" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
"
package "hipchat4"
