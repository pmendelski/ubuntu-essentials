#!/bin/bash

# Chromium
package "chromium-browser" 
package "chromium-codecs-ffmpeg-extra"
package "pepperflashplugin-nonfree"

script_after "
sudo update-pepperflashplugin-nonfree --install
"

