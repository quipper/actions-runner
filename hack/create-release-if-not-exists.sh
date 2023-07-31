#!/bin/bash
set -eux

# find the runner version in Dockerfile
actions_runner_version="$(grep RUNNER_VERSION= Dockerfile | cut -f2 -d=)"

# post a comment if pull request
if [[ $GITHUB_EVENT_NAME == pull_request ]]; then
  if gh release view "$actions_runner_version"; then
    gh pr comment "$GITHUB_HEAD_REF" --body ":warning: After merge, you may need to create a next release."
    exit
  fi

  gh pr comment "$GITHUB_HEAD_REF" --body ":warning: After merge, GitHub Actions will automatically create a release ${actions_runner_version}."
  exit
fi

if gh release view "$actions_runner_version"; then
  exit # already exists
fi

# create a release if not exists
gh release create "$actions_runner_version" --generate-notes
