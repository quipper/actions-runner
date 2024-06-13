#!/bin/bash
sudo bash /entrypoint.d/modify-apt-sources.sh
sudo /usr/bin/dockerd --log-level warn &
exec "$@"
