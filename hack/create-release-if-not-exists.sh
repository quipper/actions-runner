#!/bin/bash
set -eux

set_comment_output () {
  echo "comment=$*" >> "$GITHUB_OUTPUT"
}

actions_runner_version="$(docker run --rm "$RUNNER_IMAGE_URI" /home/runner/bin/Runner.Listener --version)"
if ! echo "$actions_runner_version" | egrep '^[0-9]+?\.[0-9]+?\.[0-9]+?$'; then
  echo "Invalid runner version: $actions_runner_version" >&2
  exit 1
fi

if gh release view "$actions_runner_version"; then
  if [[ $GITHUB_EVENT_NAME == pull_request ]]; then
    set_comment_output ":bulb: If you need a new version, [create a new release](https://github.com/quipper/actions-runner/releases/new) after merge."
  fi
  exit
fi

if [[ $GITHUB_EVENT_NAME == pull_request ]]; then
  set_comment_output ":robot: GitHub Actions will automatically create a release ${actions_runner_version} after merge."
  exit
fi

# Create a release if not exists
GITHUB_TOKEN="$RELEASE_TOKEN" gh release create "$actions_runner_version" --generate-notes

set_comment_output ":robot: GitHub Actions automatically created a new release ${actions_runner_version}"
