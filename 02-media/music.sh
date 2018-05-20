#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# Music tag tools
snap picard

# Music player
snap deepin-music
snap google-play-music-desktop-player

# Sound format converter
package soundconverter

# Spotify
snap spotify