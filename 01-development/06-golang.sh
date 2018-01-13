#!/bin/bash

repository "ppa:gophers/archive"
package "golang-1.9"

script_after '
for bin in /usr/lib/go-1.9/bin/* ; do
    sudo update-alternatives --install /usr/bin/$(basename $bin) $(basename $bin) $bin 0
    sudo update-alternatives --set $(basename $bin) $bin
done
'
