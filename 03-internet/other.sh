#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# The best torrent client
package deluge

# Dropbox client
package nautilus-dropbox

# Skype
snap skype
