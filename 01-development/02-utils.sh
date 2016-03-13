#!/bin/bash

# HTTP clients
package "curl"
package "httpie"

# JSON parser
package "jq"

# Geeky editor
package	"vim"

# Pygmentize
package	"python-pygments"

# Pure fun
# Quote of the day
package "fortune"
# Funny creatures
# fortune | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1)
# for f in `cowsay -l | tac | head -n -1 | tac | tr ' ' '\n' | sort`; do
#     cowsay -f $f "Hello from $f"
# done
package "cowsay"
# Ascii art
# figlet -f slant <Some Text>
package "figlet"
