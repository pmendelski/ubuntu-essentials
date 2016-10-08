#!/bin/bash

# nautilus
package "nautilus-actions"

# gedit plugins
package "gedit-plugins"

# conky
package "conky" "conky-all"

# sticky notes
repository "ppa:umang/indicator-stickynotes"
package "indicator-stickynotes"

# alarm clock
package "alarm-clock-applet"

# redshift
package "redshift-gtk"

# compiz configuration
package "compizconfig-settings-manager"
package "compiz-plugins-extra"
package "dconf-editor"

# nice system info
package "screenfetch"

# Logitech unifying receiver
# http://www.omgubuntu.co.uk/2013/12/logitech-unifying-receiver-linux-solaar
# repository "ppa:daniel.pavel/solaar"
# package "solaar"

# Unity tweak tool
# Go to Dash > Unity tweak tool > themes
package "unity-tweak-tool"

# Arc ubuntu theme
script_before "
echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' | sudo tee /etc/apt/sources.list.d/arc-theme.list
wget -qO - http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key | sudo apt-key add -
"
package "arc-theme"

# Moka icon theme
repository "ppa:moka/daily"
package "moka-icon-theme"

# Wallpapers from previous versions
package "ubuntu-wallpapers-karmic"
package "ubuntu-wallpapers-lucid"
package "ubuntu-wallpapers-maverick"
package "ubuntu-wallpapers-natty"
package "ubuntu-wallpapers-oneiric"
package "ubuntu-wallpapers-precise"
package "ubuntu-wallpapers-quantal"
package "ubuntu-wallpapers-raring"
package "ubuntu-wallpapers-saucy"
package "ubuntu-wallpapers-trusty"
package "ubuntu-wallpapers-utopic"
package "ubuntu-wallpapers-vivid"
package "ubuntu-wallpapers-wily"
package "ubuntu-wallpapers-xenial"
