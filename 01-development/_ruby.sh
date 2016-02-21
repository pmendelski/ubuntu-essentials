#!/bin/bash

# http://ryanbigg.com/2010/12/ubuntu-ruby-rvm-rails-and-you/
# https://rvm.io/integration/gnome-terminal
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -L get.rvm.io | bash -s stable --auto

# Load RVM into a shell session *as a function*
# echo '[[ -s \"$HOME/.rvm/scripts/rvm\" ]] && source \"$HOME/.rvm/scripts/rvm\"' >> $HOME/.bashrc 
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"

rvm requirements
rvm install 2.0.0

# http://rvm.io/integration/bundler
# bundler
gem install rubygems-bundler
gem regenerate_binstubs
gem install rails -v 4.0.0
gem install rhc

