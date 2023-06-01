#!/bin/bash
sudo /usr/bin/dockerd &
exec "$@"
