#!/bin/bash
# This is a dockerized version of webgen
# There were issues setting up the ppa for ubuntu at the time,
# similar to https://github.com/rvm/ubuntu_rvm/issues/8
set -eu
rm -f webgen.cache || true
rm -rf out || true
if [[ "$(find src/downloads -iname '*.deb' | wc -l)" = "0" ]]; then
	echo "$0: Warning: Could not find any .deb files in src/downloads, continuing anyway" 1>&2
fi
sudo docker build -t uniqush-www-build .
# TODO: Need to be root to "bundle install" before running webgen, but want -u $UID.
# For now, manually change ownership of new files
sudo docker run --rm -v $PWD:/webgen uniqush-www-build /webgen/webgen-run.sh
sudo chown $USER:$USER -R out
