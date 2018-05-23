# Ubuntu essentials

My personal Ubuntu Desktop 18.04 essential packages.

## How to use it

```sh
# Install packages from a single file
./00-system/01-base.sh

# Install all packages
./install.sh

# Install packages from a directory 00-system
./install.sh 00-system

# Install packages starting from a given file
# (good way to restart installation after a failure)
./install.sh -s 00-system/02-editors.sh

# Clean up package managers like apt
./cleanup.sh
```
