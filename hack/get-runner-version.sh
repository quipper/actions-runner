#!/bin/bash
set -eux -o pipefail

: "$RUNNER_IMAGE_URI"

runner_version="$(docker run -q --rm --entrypoint= "$RUNNER_IMAGE_URI" /home/runner/bin/Runner.Listener --version)"
if ! egrep '^[0-9]+?\.[0-9]+?\.[0-9]+?$' <<< "$runner_version"; then
  echo "Invalid runner version: $runner_version" >&2
  exit 1
fi

echo "runner-version=$runner_version" >> "$GITHUB_OUTPUT"
