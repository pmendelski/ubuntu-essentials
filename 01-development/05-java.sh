#!/bin/bash

# Default JRE is needed for swing/awt applications
package "default-jre"

# Newest JDK for programming purposes
repository "ppa:webupd8team/java"
package "oracle-java9-installer"

# Basic measurement tool
package "jmeter"

script_after "
sudo rm -f /usr/lib/jvm/default
sudo ln -s /usr/lib/jvm/java-9-oracle /usr/lib/jvm/default
"
