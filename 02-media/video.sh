#!/bin/bash

package "vlc"
package "ffmpeg"
package "qnapi"

# Video DVD
# http://ubuntuforums.org/showthread.php?t=1607915&p=10039218#post10039218
package "libdvdread4" "libdvdnav4"
script_after "
sudo /usr/share/doc/libdvdread4/install-css.sh
"
