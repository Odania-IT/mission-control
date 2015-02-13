#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
set -x

minimal_apt_get_install haproxy

## Install haproxy runit service.
mkdir /etc/haproxy-runit
cp /srv/agent/docker/runit/haproxy /etc/haproxy-runit/run
