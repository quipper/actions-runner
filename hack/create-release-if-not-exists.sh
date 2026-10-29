#!/bin/bash
set -eux -o pipefail

: "$RUNNER_VERSION"

if gh release view "$RUNNER_VERSION"; then
  exit
fi

gh release create "$RUNNER_VERSION" --target "$GITHUB_SHA" --generate-notes
