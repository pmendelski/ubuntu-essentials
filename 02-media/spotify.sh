script_before "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886"
repository "deb http://repository.spotify.com stable non-free"
package "spotify-client"

# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
# sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free"
# sudo apt-get update
# sudo apt-get install spotify-client
