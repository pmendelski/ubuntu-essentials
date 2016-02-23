#!/bin/bash

repository "ppa:webupd8team/java"
package "oracle-java8-installer"

script_after "
sudo rm -f /usr/lib/jvm/default
sudo ln -s /usr/lib/jvm/java-8-oracle /usr/lib/jvm/default
"
