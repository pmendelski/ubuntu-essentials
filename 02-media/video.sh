#!/bin/bash

package "vlc"
package "qnapi"

# Video DVD
# http://ubuntuforums.org/showthread.php?t=1607915&p=10039218#post10039218
package "libdvdread4" "libdvdnav4"
script_after	"
sudo /usr/share/doc/libdvdread4/install-css.sh
"

# http://askubuntu.com/questions/362745/how-to-install-h-265-hevc-codec-on-ubuntu-linux
repository "ppa:strukturag/libde265"
package "vlc-plugin-libde265"

