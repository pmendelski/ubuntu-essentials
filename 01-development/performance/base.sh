#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../../utils/install.sh

package "apache2-utils"
package "jmeter"
