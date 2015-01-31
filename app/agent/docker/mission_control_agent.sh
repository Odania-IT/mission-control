#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
source /etc/environment
set -x

## Install docker watch runit service.
mkdir /etc/service/docker_watch
cp /srv/agent/docker/runit/docker_watch /etc/service/docker_watch/run

## Install docker starter runit service.
mkdir /etc/service/docker_starter
cp /srv/agent/docker/runit/docker_starter /etc/service/docker_starter/run

## Install proxy updater runit service.
mkdir /etc/service/proxy_updater
cp /srv/agent/docker/runit/proxy_updater /etc/service/proxy_updater/run
