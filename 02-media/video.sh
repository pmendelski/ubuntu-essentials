#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# Best movie player
snap vlc
snap ffmpeg

# Subtitle downloader
package qnapi

# Camera recorder
package cheese

# Screen recorder
package kazam
