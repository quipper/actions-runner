#!/bin/bash
set -x
sudo /usr/bin/dockerd --log-level warn &

# Cancel the current job when the pod is deleting.
shutdown_listener() {
  sudo pkill -INT Runner.Listener
}
trap shutdown_listener SIGTERM

exec "$@"
