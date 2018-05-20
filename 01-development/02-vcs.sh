#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# GIT
repository ppa:git-core/ppa
package git
package gitk
package gitg
package meld

# SVN
package subversion

# Mercurial
package mercurial

