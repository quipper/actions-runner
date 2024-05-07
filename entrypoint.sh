#!/bin/bash
sudo /usr/bin/dockerd --log-level warn &
exec "$@"
