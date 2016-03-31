#!/bin/bash

# System autostart deamons
package "sysv-rc-conf"

# Rar/zip
package "unace"
package "unrar"
package "zip"
package "unzip"
package "p7zip-full"
package "p7zip-rar"
package "sharutils"
package "rar"
package "uudeview"
package "mpack"
package "arj"
package "cabextract"
package "file-roller"
package "unp"
package "alien"

# Mounting remote file system by ssh
package "sshfs"

# Terminator - better terminal
package "terminator"
script_after "
gconftool --type string --set /desktop/gnome/applications/terminal/exec terminator
"

# Wine
package "wine"

# Copy to clipboard
package "xclip"
package "xsel"

# Utils like: sponge
package "moreutils"
package "tree"
