#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
set -x

minimal_apt_get_install nginx

## Install haproxy runit service.
mkdir /etc/service/nginx
cp /srv/agent/docker/runit/nginx /etc/service/nginx/run
cp /srv/agent/docker/config/nginx.conf /etc/nginx/nginx.conf
touch /etc/service/nginx/down
