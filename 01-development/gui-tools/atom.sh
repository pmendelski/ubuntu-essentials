#!/bin/bash

# atom
repository "ppa:webupd8team/atom"
package "atom"

script_after "
apm install \
    editorconfig \
    highlight-line \
    highlight-selected \
    linter \
    linter-eslint \
    linter-lua \
    language-lua \
    merge-conflicts \
    minimap \
    minimap-highlight-selected \
    filesize \
    git-plus \
    file-icons \
    autoupdate-packages \
    autocomplete-modules \
    pigments \
    docblockr \
    pretty-json \
    emmet
"
