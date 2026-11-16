#!/bin/bash

dockerd_args=(--log-level warn)

# The runner container sees the cgroup tree of the node.
# dockerd would create the cgroups of job containers at the root of the node,
# so the pod memory limit would not apply to them.
# Put them under the pod cgroup, so that the pod limit applies to them.
pod_cgroup="$(dirname "$(cut -d: -f3 /proc/self/cgroup)")"
if [[ -f /sys/fs/cgroup/cgroup.controllers && "$pod_cgroup" == *kubepods* ]]; then
  dockerd_args+=(--cgroup-parent "$pod_cgroup")
fi

sudo /usr/bin/dockerd "${dockerd_args[@]}" &
exec "$@"
