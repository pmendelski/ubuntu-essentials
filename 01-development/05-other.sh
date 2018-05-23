#!/bin/bash -e

source $(dirname "${BASH_SOURCE[0]}")/../utils/install.sh

printInfo "Installing Java"
repository ppa:webupd8team/java
# Auo accept license agreement
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | sudo debconf-set-selections
package oracle-java8-set-default
java -version

printInfo "Installing Lua"
# there is a problem with lua5.3
package lua5.2
lua -v

printInfo "Installing Python2"
package python-dev
package python
package python-pip
python -V

printInfo "Installing Python3"
package python3
package python3-venv
package python3-pip
python3 -V
