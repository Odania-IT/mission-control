#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
set -x

minimal_apt_get_install haproxy

## Install haproxy runit service.
mkdir /etc/service/haproxy
cp /srv/agent/docker/runit/haproxy /etc/service/haproxy/run
