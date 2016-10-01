#!/bin/bash -e

# Basic ui changes
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ panel-opacity 0.36
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ panel-opacity-maximized-toggle true

declare -r plugins="$(gsettings get org.compiz.core:/org/compiz/profiles/unity/plugins/core/ active-plugins)"
# Activating put plugin http://wiki.compiz.org/Plugins/Put
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ active-plugins "$(echo $plugins | sed "s|\]|, 'put'\]|")"
gsettings set org.compiz.put:/org/compiz/profiles/unity/plugins/put/ put-previous-output-key '<Shift><Alt>KP_Left'
gsettings set org.compiz.put:/org/compiz/profiles/unity/plugins/put/ put-next-output-key '<Shift><Alt>KP_Right'
gsettings set org.compiz.put:/org/compiz/profiles/unity/plugins/put/ speed 5.5
gsettings set org.compiz.put:/org/compiz/profiles/unity/plugins/put/ timestep 0.25


# Setup terminal profiles to Solarized Dark
profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
profile=${profile:1:-1} # remove leading and trailing single quotes
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" audible-bell true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" cursor-shape 'block'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" scroll-on-keystroke true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" cjk-utf8-ambiguous-width 'narrow'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" default-size-rows 24
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" encoding 'UTF-8'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-theme-colors false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" custom-command ''
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" visible-name 'Unnamed'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" login-shell false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" exit-action 'close'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-system-font true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" rewrap-on-resize true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" backspace-binding 'ascii-delete'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" foreground-color 'rgb(131,148,150)'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-theme-transparency false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-transparency-percent 4
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" bold-color-same-as-fg true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" cursor-blink-mode 'system'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" default-show-menubar true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" default-size-columns 80
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-color 'rgb(0,43,54)'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" palette ['#2E2E34343636', '#CCCC00000000', '#4E4E9A9A0606', '#C4C4A0A00000', '#34346565A4A4', '#757550507B7B', '#060698209A9A', '#D3D3D7D7CFCF', '#555557575353', '#EFEF29292929', '#8A8AE2E23434', '#FCFCE9E94F4F', '#72729F9FCFCF', '#ADAD7F7FA8A8', '#3434E2E2E2E2', '#EEEEEEEEECEC']
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" allow-bold true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-transparent-background true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" font 'Monospace 12'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" delete-binding 'delete-sequence'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" scrollback-unlimited true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" word-char-exceptions @ms nothing
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" scroll-on-output false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" scrollbar-policy 'never'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-custom-command false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" bold-color '#000000'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" scrollback-lines 8192

# Gedit preferences
gsettings set org.gnome.gedit.plugins active-plugins ['dashboard', 'spell', 'commander', 'colorschemer', 'wordcompletion', 'findinfiles', 'colorpicker', 'bracketcompletion', 'modelines', 'textsize', 'terminal', 'filebrowser', 'smartspaces', 'multiedit', 'docinfo', 'joinlines', 'quickopen', 'codecomment', 'git', 'time', 'drawspaces', 'sort']
gsettings set org.gnome.gedit.preferences.editor wrap-mode 'none'
gsettings set org.gnome.gedit.preferences.editor display-right-margin false
gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
gsettings set org.gnome.gedit.preferences.editor search-highlighting true
gsettings set org.gnome.gedit.preferences.editor display-overview-map true
gsettings set org.gnome.gedit.preferences.editor create-backup-copy false
gsettings set org.gnome.gedit.preferences.editor auto-save false
gsettings set org.gnome.gedit.preferences.editor restore-cursor-position true
gsettings set org.gnome.gedit.preferences.editor bracket-matching true
gsettings set org.gnome.gedit.preferences.editor scheme 'solarized-dark'
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor editor-font 'Monospace 12'
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
gsettings set org.gnome.gedit.preferences.editor right-margin-position uint32 80
gsettings set org.gnome.gedit.preferences.editor tabs-size uint32 4
gsettings set org.gnome.gedit.preferences.editor background-pattern 'none'
gsettings set org.gnome.gedit.preferences.editor use-default-font true
gsettings set org.gnome.gedit.preferences.editor ensure-trailing-newline true
gsettings set org.gnome.gedit.preferences.editor wrap-last-split-mode 'word'
gsettings set org.gnome.gedit.preferences.editor smart-home-end 'after'
gsettings set org.gnome.gedit.preferences.editor auto-indent true
gsettings set org.gnome.gedit.preferences.editor max-undo-actions 2000
gsettings set org.gnome.gedit.preferences.editor auto-save-interval uint32 10
gsettings set org.gnome.gedit.preferences.editor syntax-highlighting true

# Setup default applications
# https://wiki.archlinux.org/index.php/Default_applications
# cat ~/.config/mimeapps.list
#
# Add inbox as default email client
# Add google calendar as default
# Fix home in startup files
# Get sublime from webpage
# sudo vim /usr/share/applications/chromium-browser.desktop
#
# Prompt settings
# PROMPT_DEFAULT_USERHOST="pawel.mendelski@polpc02153"
# __FLEXI_PROMPT_SHLVL=2
