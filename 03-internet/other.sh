#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# The best torrent client
package deluge

# Dropbox client
package nautilus-dropbox

# Skype
snap skype

# Hipchat - Atlassian communicator
# Hipchat is not released for Ubuntu18. See: https://community.atlassian.com/t5/Hipchat-questions/Installing-on-Ubuntu-18-04/qaq-p/779966
# sudo sh -c 'echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
# wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
# sudo apt-get update
# sudo apt-get install hipchat4