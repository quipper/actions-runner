#!/bin/bash
set -eux -o pipefail

: "$RUNNER_VERSION"

set_comment_output () {
  echo "comment=$*" >> "$GITHUB_OUTPUT"
}

if gh release view "$RUNNER_VERSION"; then
  if [[ $GITHUB_EVENT_NAME == pull_request ]]; then
    set_comment_output ":bulb: If you need a new version, [create a new release](https://github.com/quipper/actions-runner/releases/new) after merge."
  fi
  exit
fi

if [[ $GITHUB_EVENT_NAME == pull_request ]]; then
  set_comment_output ":robot: GitHub Actions will automatically create a release ${RUNNER_VERSION} after merge."
  exit
fi

# Create a release if not exists
GITHUB_TOKEN="$RELEASE_TOKEN" gh release create "$RUNNER_VERSION" --generate-notes

set_comment_output ":robot: GitHub Actions automatically created a new release ${RUNNER_VERSION}"
