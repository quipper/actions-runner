#!/bin/bash
set -eux

# find the runner version in Dockerfile
actions_runner_version="$(grep RUNNER_VERSION= Dockerfile | cut -f2 -d=)"

if gh release view "$actions_runner_version"; then
  if [[ $GITHUB_EVENT_NAME == pull_request ]]; then
    gh pr comment --body-file - <<EOF
:warning: After merge, you may need to create a next release.
EOF
  fi

  # the corresponding release already exists
  exit
fi

if [[ $GITHUB_EVENT_NAME == pull_request ]]; then
  gh pr comment --body-file - <<EOF
:warning: After merge, GitHub Actions will automatically create a new release ${actions_runner_version}.
EOF
  exit
fi

# create a release if not exists
gh release create "$actions_runner_version" --generate-notes
