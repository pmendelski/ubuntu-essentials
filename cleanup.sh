#!/bin/bash -e

sudo apt-get update
sudo apt-get clean
sudo apt-get autoremove
sudo apt-get update && sudo apt-get upgrade
sudo dpkg --configure -a
