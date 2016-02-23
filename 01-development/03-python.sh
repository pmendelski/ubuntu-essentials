#!/bin/bash

package "python-dev"
package "python-pip"
package "python-software-properties"

script_after "
sudo pip install pymongo
"
