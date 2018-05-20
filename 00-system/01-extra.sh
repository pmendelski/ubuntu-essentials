#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# File manager context actions
# Not yet available:( See: https://askubuntu.com/questions/1030940/nautilus-actions-in-18-04
# package "nautilus-actions"
# package "filemanager-actions"

# disk partitioning tool
package gparted

# wine
package wine-stable

# conky
package conky
package conky-all

# GUI for GnuPG
package seahorse
package seahorse-nautilus

# Pure fun
# Quote of the day
package fortune
# Funny creatures
# fortune | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1)
# for f in `cowsay -l | tac | head -n -1 | tac | tr ' ' '\n' | sort`; do
#     cowsay -f $f "Hello from $f"
# done
package cowsay
# Ascii art
# figlet -f slant <Some Text>
package figlet

# Logitech unifying receiver
# http://www.omgubuntu.co.uk/2013/12/logitech-unifying-receiver-linux-solaar
# package "solaar"
# package "solaar-gnome3"