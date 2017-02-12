#!/bin/bash

# Chromium
package "chromium-browser"
package "chromium-codecs-ffmpeg-extra"
package "pepperflashplugin-nonfree"
script_after "
sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/chromium-browser 50
sudo update-pepperflashplugin-nonfree --install
"

# Chrome
script_before "
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo \"deb http://dl.google.com/linux/chrome/deb/ stable main\" >> /etc/apt/sources.list.d/google-chrome.list'
"
package "google-chrome-stable"
