#!/bin/bash
sudo find /entrypoint.d -type f -name '*.sh' -exec bash {} \;
sudo /usr/bin/dockerd --log-level warn &
exec "$@"
