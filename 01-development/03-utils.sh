#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# HTTP clients
package curl
package httpie

# HTTP utils like dig
package dnsutils

# JSON parser
package jq

# Penetration testing tools
package aircrack-ng
package john
package macchanger

# Wireshark
# https://ask.wireshark.org/questions/7523/ubuntu-machine-no-interfaces-listed
package wireshark
printInfo "Configuring Wireshark"
sudo groupadd -f wireshark
sudo usermod -a -G wireshark $USER
sudo chgrp wireshark /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
