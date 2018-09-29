#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# Wallpapers from previous versions
package ubuntu-wallpapers-karmic
package ubuntu-wallpapers-lucid
package ubuntu-wallpapers-maverick
package ubuntu-wallpapers-natty
package ubuntu-wallpapers-oneiric
package ubuntu-wallpapers-precise
package ubuntu-wallpapers-quantal
package ubuntu-wallpapers-raring
package ubuntu-wallpapers-saucy
package ubuntu-wallpapers-trusty
package ubuntu-wallpapers-utopic
package ubuntu-wallpapers-vivid
package ubuntu-wallpapers-wily
package ubuntu-wallpapers-xenial
package ubuntu-wallpapers-artful

# Community Theme
# Restart -> Login Screen: Change session (the cog icon) to 'Communitheme' -> Tweak Tool: Change icons to 'Siri' and application theme to 'Communitheme'
snap communitheme
package gnome-tweak-tool

# Gnome extensions
package gnome-shell-extensions
package chrome-gnome-shell

# Install extensions:
# https://extensions.gnome.org/extension/545/hide-top-bar/
# https://extensions.gnome.org/extension/1272/mconnect/
# https://extensions.gnome.org/extension/779/clipboard-indicator/
# https://extensions.gnome.org/extension/1319/gsconnect/
# https://chrome.google.com/webstore/detail/gsconnect/jfnifeihccihocjbfcfhicmmgpjicaec
# https://addons.mozilla.org/firefox/addon/gsconnect/
# https://extensions.gnome.org/extension/723/pixel-saver/
# https://extensions.gnome.org/extension/744/hide-activities-button/
# https://extensions.gnome.org/extension/39/put-windows/
# https://extensions.gnome.org/extension/1267/no-title-bar/

# Needed for system monitor applet
# https://extensions.gnome.org/extension/120/system-monitor/ - it's the best but sometimes freezes
# https://extensions.gnome.org/extension/1043/gnomestatspro/ - alternative
package gir1.2-gtop-2.0
package gir1.2-networkmanager-1.0
package gir1.2-clutter-1.0
