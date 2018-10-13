#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# Music tag tools
snap picard

# Music player
package audacious

# Music editor
snap audacity

# Sound format converter
package soundconverter

# Spotify
snap spotify
