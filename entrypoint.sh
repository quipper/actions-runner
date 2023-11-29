#!/bin/bash
set -eux -o pipefail

function populate_hostedtoolcache() {
  sudo mkdir -p "$RUNNER_TOOL_CACHE"
  sudo chown -R runner:docker "$RUNNER_TOOL_CACHE"
  cp -a /assets/hostedtoolcache/* "$RUNNER_TOOL_CACHE"
  sudo chown -R runner:docker "$RUNNER_TOOL_CACHE"
}

sudo /usr/bin/dockerd &
populate_hostedtoolcache
exec "$@"
