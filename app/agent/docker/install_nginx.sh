#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
set -x

minimal_apt_get_install nginx apache2-utils

## Install haproxy runit service.
mkdir /etc/nginx-runit
cp /srv/agent/docker/runit/nginx /etc/nginx-runit/run
cp /srv/agent/docker/config/nginx.conf /etc/nginx/nginx.conf

# Set the default site
rm /etc/nginx/sites-enabled/default

# setup nginx log forwarder
mkdir /etc/service/nginx-log-forwarder
cp /srv/agent/docker/runit/nginx-log-forwarder /etc/service/nginx-log-forwarder/run
