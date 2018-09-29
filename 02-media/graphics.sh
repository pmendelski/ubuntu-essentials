#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

# Gimp
package gimp
package gimp-data
package gimp-plugin-registry
package gimp-data-extras

# Inkscape
snap inkscape
