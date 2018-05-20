#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# Geeky editor
package vim-gtk
package vim-nox

# Gedit plugins
package gedit-plugins

# Sublime
snap sublime-text

# Atom
snap atom
printInfo "Installing atom packages"
apm install \
  editorconfig \
  docblockr \
  highlight-line \
  highlight-selected \
  linter \
  linter-tslint \
  linter-eslint \
  linter-lua \
  language-lua \
  merge-conflicts \
  minimap \
  minimap-highlight-selected \
  filesize \
  file-icons \
  autoupdate-packages \
  autocomplete-modules \
  pigments \
  pretty-json \
  emmet
