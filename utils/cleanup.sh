#!/bin/bash -e

# Clean apt-get registry
sudo apt-get update
sudo apt-get clean
sudo apt-get autoremove
sudo apt-get update && sudo apt-get upgrade
