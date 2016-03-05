#!/bin/bash

# sublime
repository "ppa:webupd8team/sublime-text-3"
package "sublime-text-installer"

script_after "
[ -f /usr/bin/sublime ] && \
    printDebug 'Sublime link already created' || \
    sudo ln -s /opt/sublime_text/sublime_text /usr/bin/sublime
"
