#!/bin/bash
set -e
source /srv/agent/docker/buildconfig
set -x

# Workaround for hash sum mismatch http://forum.siduction.org/index.php?topic=4294.0
rm -rf /var/lib/apt/lists

/srv/agent/docker/enable_repos.sh
/srv/agent/docker/utilities.sh

/srv/agent/docker/ruby2.1.sh

cd /srv/agent
bundle install

/srv/agent/docker/mission_control_agent.sh
/srv/agent/docker/install_haproxy.sh
/srv/agent/docker/install_nginx.sh

# Disable ssh
touch /etc/service/sshd/down

# Install backup dependencies
minimal_apt_get_install mysql-client

/srv/agent/docker/finalize.sh
