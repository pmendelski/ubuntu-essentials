#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# Better terminal
package tmux
package zsh

# Rar/zip
package unace
package unrar
package zip
package unzip
package p7zip-full
package p7zip-rar
package sharutils
package rar
package uudeview
package mpack
package arj
package cabextract
package file-roller
package unp
package alien

# Installer for .deb packages
package gdebi-core

# Mounting remote file system by ssh
package sshfs

# Copy to clipboard
package xclip
package xsel

# Utils like: sponge
package moreutils
package tree

# Looking for files inside packages
# Example: apt-file search /usr/lib/jvm/java-6-openjdk/jre/lib/i386/xawt/libmawt.so
# See: https://www.howtoforge.com/apt_file_debian_ubuntu
package apt-file
printInfo "Updating apt-file index"
sudo apt-file update

