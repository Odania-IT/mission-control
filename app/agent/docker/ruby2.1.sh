#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
set -x

minimal_apt_get_install ruby2.1 ruby2.1-dev
gem2.1 install rake bundler --no-rdoc --no-ri
/srv/agent/docker/ruby-finalize.sh
