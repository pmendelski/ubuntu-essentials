#!/bin/bash

# make nautilus sort the way it should sort
sudo update-locale LC_COLLATE=C

# remove bloatware
sudo apt-get remove unity-lens-shopping

# Remove screen reader
sudo apt-get remove gnome-orca
