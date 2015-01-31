#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
set -x

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
