#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
set -x

/srv/agent/docker/enable_repos.sh
/srv/agent/docker/prepare.sh
/srv/agent/docker/utilities.sh

/srv/agent/docker/ruby2.1.sh

cd /srv/agent
bundle install

/srv/agent/docker/mission_control_agent.sh
/srv/agent/docker/install_haproxy.sh

# Disable ssh
touch /etc/service/sshd/down

/srv/agent/docker/finalize.sh
