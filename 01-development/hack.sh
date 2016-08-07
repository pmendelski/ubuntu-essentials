#!/bin/bash

package "aircrack-ng"
package "john"
package "macchanger"

# Wireshark
# https://ask.wireshark.org/questions/7523/ubuntu-machine-no-interfaces-listed
package "wireshark"
script_after "
sudo groupadd -f wireshark
sudo usermod -a -G wireshark $USER
sudo chgrp wireshark /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
"
