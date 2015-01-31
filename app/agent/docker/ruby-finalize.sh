#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
set -x

## This script is to be run after ruby1.9.sh, ruby2.0.sh and ruby2.1.sh.

cp /srv/agent/docker/ruby-switch /usr/local/bin/ruby-switch
echo "gem: --no-ri --no-rdoc" > /etc/gemrc

## Fix shebang lines in rake and bundler so that they're run with the currently
## configured default Ruby instead of the Ruby they're installed with.
sed -i 's|/usr/bin/env ruby.*$|/usr/bin/env ruby|; s|/usr/bin/ruby.*$|/usr/bin/env ruby|' \
	/usr/local/bin/rake /usr/local/bin/bundle /usr/local/bin/bundler

## Install development headers for native libraries that tend to be used often by Ruby gems.

minimal_apt_get_install libcurl4-openssl-dev
minimal_apt_get_install zlib1g-dev

## Set the latest available Ruby as the default.
ruby-switch --set ruby2.1
